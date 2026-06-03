// lib/data/ggpen_models.dart
// Modelos que espelham as tabelas do Supabase.

class AppEvent {
  final String id;
  final String nome;
  final String? descricao;
  final String? bannerUrl;
  final String? local;
  final DateTime? inicio;
  final DateTime? fim;

  AppEvent({
    required this.id,
    required this.nome,
    this.descricao,
    this.bannerUrl,
    this.local,
    this.inicio,
    this.fim,
  });

  factory AppEvent.fromMap(Map<String, dynamic> m) => AppEvent(
        id: m['id'] as String,
        nome: m['nome'] as String,
        descricao: m['descricao'] as String?,
        bannerUrl: m['banner_url'] as String?,
        local: m['local'] as String?,
        inicio: m['inicio'] != null ? DateTime.parse(m['inicio'] as String) : null,
        fim: m['fim'] != null ? DateTime.parse(m['fim'] as String) : null,
      );
}

class Activity {
  final String id;
  final String eventId;
  final String titulo;
  final String tipo; // apresentacao | lancamento | assinatura | painel | workshop | outro
  final String? descricao;
  final String? local;
  final DateTime inicio;
  final DateTime? fim;

  Activity({
    required this.id,
    required this.eventId,
    required this.titulo,
    required this.tipo,
    this.descricao,
    this.local,
    required this.inicio,
    this.fim,
  });

  factory Activity.fromMap(Map<String, dynamic> m) => Activity(
        id: m['id'] as String,
        eventId: m['event_id'] as String,
        titulo: m['titulo'] as String,
        tipo: m['tipo'] as String,
        descricao: m['descricao'] as String?,
        local: m['local'] as String?,
        inicio: DateTime.parse(m['inicio'] as String),
        fim: m['fim'] != null ? DateTime.parse(m['fim'] as String) : null,
      );
}

class Speaker {
  final String id;
  final String nome;
  final String? organizacao;
  final String? bio;
  final String? avatarUrl;
  final String papel; // 'orador' | 'moderador' (vem da ligacao activity_speakers)
  final int? ordem; // posicao definida no painel (menor = primeiro)

  Speaker({
    required this.id,
    required this.nome,
    this.organizacao,
    this.bio,
    this.avatarUrl,
    this.papel = 'orador',
    this.ordem,
  });

  factory Speaker.fromMap(Map<String, dynamic> m, {String papel = 'orador'}) => Speaker(
        id: m['id'] as String,
        nome: m['nome'] as String,
        organizacao: m['organizacao'] as String?,
        bio: m['bio'] as String?,
        avatarUrl: m['avatar_url'] as String?,
        papel: papel,
        ordem: (m['ordem'] as num?)?.toInt(),
      );
}

class Question {
  final String id;
  final String activityId;
  final String autorId;
  final String? autorNome; // pode ser "Anónimo"
  final String texto;
  final String status; // pending | approved | rejected
  final DateTime createdAt;
  final int likes;

  Question({
    required this.id,
    required this.activityId,
    required this.autorId,
    this.autorNome,
    required this.texto,
    required this.status,
    required this.createdAt,
    this.likes = 0,
  });

  factory Question.fromMap(Map<String, dynamic> m) => Question(
        id: m['id'] as String,
        activityId: m['activity_id'] as String,
        autorId: m['autor_id'] as String,
        autorNome: m['autor_nome'] as String?,
        texto: m['texto'] as String,
        status: m['status'] as String,
        createdAt: DateTime.parse(m['created_at'] as String),
        likes: (m['likes'] as int?) ?? 0, // a view traz 'likes'; a stream da tabela nao
      );
}