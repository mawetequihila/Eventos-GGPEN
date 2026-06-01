// lib/data/ggpen_repository.dart
// Toda a conversa com o Supabase passa por aqui.
// Leitura = publica (sem login). Escrita = precisa de login Google.
// App so de participantes: sem operacoes de admin/moderacao (isso vive no
// painel Next.js que partilha o mesmo backend).

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ggpen_models.dart';

class GgpenRepository {
  final SupabaseClient _db = Supabase.instance.client;

  // ====================== AUTH ======================
  User? get currentUser => _db.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  /// Reage a login/logout (util para redesenhar a UI).
  Stream<AuthState> get authChanges => _db.auth.onAuthStateChange;

  Future<void> signInWithGoogle() async {
    await _db.auth.signInWithOAuth(
      OAuthProvider.google,
      // Na web volta sozinho; em mobile precisa de um deep link configurado.
      redirectTo: kIsWeb ? null : 'io.ggpen.app://login-callback/',
    );
  }

  Future<void> signOut() => _db.auth.signOut();

  // ================== LEITURA PUBLICA ==================
  Future<List<AppEvent>> getEvents() async {
    final rows = await _db.from('events').select().order('inicio');
    return rows.map(AppEvent.fromMap).toList();
  }

  /// Evento atual (o primeiro por data de inicio). A app mostra um evento de cada vez.
  Future<AppEvent> getCurrentEvent() async {
    final rows = await _db.from('events').select().order('inicio').limit(1);
    if (rows.isEmpty) {
      throw Exception('Nenhum evento encontrado.');
    }
    return AppEvent.fromMap(rows.first);
  }

  /// Todos os oradores (pagina Oradores). Sem papel associado a atividade.
  Future<List<Speaker>> getAllSpeakers() async {
    final rows = await _db.from('speakers').select().order('nome');
    return rows.map((m) => Speaker.fromMap(m)).toList();
  }

  /// Contagem de sessoes por orador (id do orador -> n.o de atividades).
  /// Usado para o "X sessoes" na pagina Oradores.
  Future<Map<String, int>> getSpeakerSessionCounts() async {
    final rows = await _db.from('activity_speakers').select('speaker_id');
    final counts = <String, int>{};
    for (final r in rows) {
      final id = r['speaker_id'] as String;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    return counts;
  }

  /// IDs das duvidas em que o utilizador atual deu gosto (vazio se sem sessao).
  /// Permite destacar os gostos ja dados.
  Future<Set<String>> getLikedQuestionIds() async {
    final user = currentUser;
    if (user == null) return <String>{};
    final rows = await _db
        .from('question_likes')
        .select('question_id')
        .eq('user_id', user.id);
    return rows.map((r) => r['question_id'] as String).toSet();
  }

  Future<List<Activity>> getActivities(String eventId) async {
    final rows = await _db
        .from('activities')
        .select()
        .eq('event_id', eventId)
        .order('inicio');
    return rows.map(Activity.fromMap).toList();
  }

  Future<Activity> getActivity(String activityId) async {
    final row = await _db.from('activities').select().eq('id', activityId).single();
    return Activity.fromMap(row);
  }

  /// Sessões em que um orador participa (para a ficha do orador).
  Future<List<Activity>> getSpeakerSessions(String speakerId) async {
    final rows = await _db
        .from('activity_speakers')
        .select('activities(*)')
        .eq('speaker_id', speakerId);
    final list = <Activity>[];
    for (final r in rows) {
      final a = r['activities'];
      if (a is Map<String, dynamic>) list.add(Activity.fromMap(a));
    }
    list.sort((x, y) => x.inicio.compareTo(y.inicio));
    return list;
  }

  /// Oradores + moderadores de uma atividade (embedding da tabela speakers).
  Future<List<Speaker>> getSpeakers(String activityId) async {
    final rows = await _db
        .from('activity_speakers')
        .select('papel, speakers(*)')
        .eq('activity_id', activityId);
    return rows.map((r) {
      final s = r['speakers'] as Map<String, dynamic>;
      return Speaker.fromMap(s, papel: r['papel'] as String);
    }).toList();
  }

  Future<List<String>> getActivityPhotos(String activityId) async {
    final rows = await _db
        .from('activity_photos')
        .select('url')
        .eq('activity_id', activityId)
        .order('created_at');
    return rows.map((r) => r['url'] as String).toList();
  }

  /// Duvidas APROVADAS de uma atividade (uma vez, com contagem de gostos).
  Future<List<Question>> getApprovedQuestions(String activityId) async {
    final rows = await _db
        .from('question_with_likes')
        .select()
        .eq('activity_id', activityId)
        .eq('status', 'approved')
        .order('created_at', ascending: false);
    return rows.map(Question.fromMap).toList();
  }

  /// Duvidas APROVADAS em TEMPO REAL (atualiza sozinho quando o admin aprova).
  /// Nota: a stream e da tabela, por isso filtramos 'approved' no cliente
  /// e a contagem de gostos vem a 0 aqui (busca com getApprovedQuestions
  /// quando precisares do numero exato).
  Stream<List<Question>> watchApprovedQuestions(String activityId) {
    return _db
        .from('questions')
        .stream(primaryKey: ['id'])
        .eq('activity_id', activityId)
        .order('created_at')
        .map((rows) => rows
            .where((r) => r['status'] == 'approved')
            .map(Question.fromMap)
            .toList());
  }

  // ================== ESCRITA (precisa login) ==================
  Future<void> submitQuestion({
    required String activityId,
    required String texto,
    bool anonimo = false,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Inicia sessao com o Google para enviar uma duvida.');
    }
    final nome = anonimo
        ? 'Anónimo'
        : (user.userMetadata?['full_name'] as String? ?? 'Participante');
    await _db.from('questions').insert({
      'activity_id': activityId,
      'autor_id': user.id,
      'autor_nome': nome,
      'texto': texto,
      // status fica 'pending' por defeito -> so aparece quando o admin aprova
    });
  }

  /// Dúvidas do próprio utilizador nesta atividade (qualquer estado).
  /// Permite ver/gerir as próprias mesmo antes de aprovadas.
  Future<List<Question>> getMyQuestions(String activityId) async {
    final user = currentUser;
    if (user == null) return <Question>[];
    final rows = await _db
        .from('questions')
        .select()
        .eq('activity_id', activityId)
        .eq('autor_id', user.id)
        .order('created_at', ascending: false);
    return rows.map(Question.fromMap).toList();
  }

  /// Edita o texto de uma dúvida do próprio (o RLS deve permitir só enquanto
  /// pendente). Lança em caso de falha de permissão.
  Future<void> updateMyQuestion(String questionId, String texto) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Inicia sessao para editar.');
    }
    await _db
        .from('questions')
        .update({'texto': texto})
        .eq('id', questionId)
        .eq('autor_id', user.id);
  }

  /// Elimina uma dúvida do próprio (o RLS deve permitir ao autor).
  Future<void> deleteMyQuestion(String questionId) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Inicia sessao para eliminar.');
    }
    await _db
        .from('questions')
        .delete()
        .eq('id', questionId)
        .eq('autor_id', user.id);
  }

  /// Da ou retira o gosto (toggle).
  Future<void> toggleLike(String questionId) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Inicia sessao com o Google para dar gosto.');
    }
    final existing = await _db
        .from('question_likes')
        .select()
        .eq('question_id', questionId)
        .eq('user_id', user.id);
    if (existing.isEmpty) {
      await _db.from('question_likes').insert({
        'question_id': questionId,
        'user_id': user.id,
      });
    } else {
      await _db
          .from('question_likes')
          .delete()
          .eq('question_id', questionId)
          .eq('user_id', user.id);
    }
  }
}