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
        inicio: m['inicio'] != null
            ? DateTime.parse(m['inicio'] as String).toLocal()
            : null,
        fim: m['fim'] != null
            ? DateTime.parse(m['fim'] as String).toLocal()
            : null,
      );
}

/// Escolhe a variante de idioma (`en`/`fr`/`ar`); null se não houver tradução
/// para esse idioma (ou se o idioma for o base, português).
String? _pickLang(String? en, String? fr, String? ar, String? lang) {
  switch (lang) {
    case 'en':
      return en;
    case 'fr':
      return fr;
    case 'ar':
      return ar;
  }
  return null;
}

class Activity {
  final String id;
  final String eventId;
  final String titulo;
  final String? tituloEn, tituloFr, tituloAr;
  final String tipo; // apresentacao|lancamento|assinatura|plenaria|paralela|painel|formacao|workshop
  final String? descricao;
  final String? descricaoEn, descricaoFr, descricaoAr;
  final String? local;
  final DateTime inicio;
  final DateTime? fim;

  Activity({
    required this.id,
    required this.eventId,
    required this.titulo,
    required this.tipo,
    this.tituloEn,
    this.tituloFr,
    this.tituloAr,
    this.descricao,
    this.descricaoEn,
    this.descricaoFr,
    this.descricaoAr,
    this.local,
    required this.inicio,
    this.fim,
  });

  /// Título no idioma [lang] (cai para o português se não houver tradução).
  String tituloFor(String? lang) {
    final v = _pickLang(tituloEn, tituloFr, tituloAr, lang);
    return (v != null && v.trim().isNotEmpty) ? v.trim() : titulo;
  }

  /// Descrição no idioma [lang] (cai para o português se não houver tradução).
  String? descricaoFor(String? lang) {
    final v = _pickLang(descricaoEn, descricaoFr, descricaoAr, lang);
    return (v != null && v.trim().isNotEmpty) ? v.trim() : descricao;
  }

  factory Activity.fromMap(Map<String, dynamic> m) => Activity(
        id: m['id'] as String,
        eventId: m['event_id'] as String,
        titulo: m['titulo'] as String,
        tituloEn: m['titulo_en'] as String?,
        tituloFr: m['titulo_fr'] as String?,
        tituloAr: m['titulo_ar'] as String?,
        tipo: m['tipo'] as String,
        descricao: m['descricao'] as String?,
        descricaoEn: m['descricao_en'] as String?,
        descricaoFr: m['descricao_fr'] as String?,
        descricaoAr: m['descricao_ar'] as String?,
        local: m['local'] as String?,
        inicio: _wallClock(m['inicio'] as String),
        fim: m['fim'] != null ? _wallClock(m['fim'] as String) : null,
      );

  /// Converte o instante guardado (timestamptz do Supabase) para a hora LOCAL
  /// do dispositivo — em Angola, UTC+1. Assim a hora mostrada e a contagem
  /// decrescente coincidem com o painel de administração (que também formata na
  /// hora local). NÃO usar `.toUtc()` aqui: isso descartava o fuso e mostrava a
  /// hora 1h mais cedo do que o organizador definiu.
  static DateTime _wallClock(String s) => DateTime.parse(s).toLocal();
}

class Speaker {
  final String id;
  final String nome;
  final String? organizacao;
  final String? organizacaoEn, organizacaoFr, organizacaoAr;
  final String? bio;
  final String? bioEn, bioFr, bioAr;
  final String? avatarUrl;
  final String? pais; // país do orador (definido no painel)
  final String? origem; // região/origem da pessoa (definido no painel)
  final String papel; // 'orador' | 'moderador' | 'convidado' (da ligacao activity_speakers)
  final int? ordem; // posicao definida no painel (menor = primeiro)

  Speaker({
    required this.id,
    required this.nome,
    this.organizacao,
    this.organizacaoEn,
    this.organizacaoFr,
    this.organizacaoAr,
    this.bio,
    this.bioEn,
    this.bioFr,
    this.bioAr,
    this.avatarUrl,
    this.pais,
    this.origem,
    this.papel = 'orador',
    this.ordem,
  });

  /// Cargo/organização no idioma [lang] (cai para o português).
  String? organizacaoFor(String? lang) {
    final v = _pickLang(organizacaoEn, organizacaoFr, organizacaoAr, lang);
    return (v != null && v.trim().isNotEmpty) ? v.trim() : organizacao;
  }

  /// Bio no idioma [lang] (cai para o português).
  String? bioFor(String? lang) {
    final v = _pickLang(bioEn, bioFr, bioAr, lang);
    return (v != null && v.trim().isNotEmpty) ? v.trim() : bio;
  }

  factory Speaker.fromMap(Map<String, dynamic> m, {String papel = 'orador'}) => Speaker(
        id: m['id'] as String,
        nome: m['nome'] as String,
        organizacao: m['organizacao'] as String?,
        organizacaoEn: m['organizacao_en'] as String?,
        organizacaoFr: m['organizacao_fr'] as String?,
        organizacaoAr: m['organizacao_ar'] as String?,
        bio: m['bio'] as String?,
        bioEn: m['bio_en'] as String?,
        bioFr: m['bio_fr'] as String?,
        bioAr: m['bio_ar'] as String?,
        avatarUrl: m['avatar_url'] as String?,
        pais: m['pais'] as String?,
        origem: m['origem'] as String?,
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