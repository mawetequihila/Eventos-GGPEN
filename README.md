# Agenda GGPEN — Angotic 2026

App Flutter da agenda da participação da **GGPEN** (Gabinete de Gestão do Programa Espacial Nacional de Angola) no **Angotic 2026** (Angola ICT Forum). Mostra a programação dos 3 dias do evento, as sessões a decorrer, a próxima sessão com contagem decrescente, os oradores convidados e permite aos participantes colocar dúvidas e gerir a sua agenda pessoal.

---

## Estado do projeto

O **front-end está concluído** (UI, navegação, estado local, dados mock). Falta a **integração com backend** — todos os dados de agenda, oradores, dúvidas e participantes são, neste momento, lidos de `lib/data/mock_data.dart`. Os pontos de integração estão claramente identificados (ver secção *Mock data → backend*).

---

## Stack

- **Flutter** 3.19+ (Dart 3.3+) — testado em 3.44.0.
- **Provider** — gestão de estado simples e idiomática.
- **shared_preferences** — persistência local (favoritos, lembretes, sessão).
- **lucide_icons_flutter** — ícones (Lucide).
- **qr_flutter** — QR codes (perfil/crachá, sessões).
- **google_fonts** — declarado em `pubspec` (atualmente o tema usa a fonte do sistema; a dependência fica disponível se quiseres carregar uma família).

Plataformas configuradas: **Web** e **Android**. iOS/macOS/Windows/Linux não estão configurados (criar via `flutter create . --platforms=ios,...` se necessário).

---

## Como correr

```bash
flutter pub get

# Web (Edge / Chrome)
flutter run -d edge --web-port=8089
flutter run -d chrome

# Android (com dispositivo ligado ou emulador)
flutter run -d <device-id>

# Lista dispositivos
flutter devices

# Verificações estáticas
flutter analyze
```

Build de produção:

```bash
flutter build web                # /build/web
flutter build apk --release      # /build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release
```

---

## Estrutura do projeto

```
lib/
  main.dart                       # bootstrap + Provider AppState
  app.dart                        # MaterialApp + tema
  state/
    app_state.dart                # estado global (Provider)
  theme/
    app_colors.dart               # paleta duotone (navy + acentos)
    app_theme.dart                # tokens (espaçamento, ícones, estilos)
  models/
    activity.dart                 # Activity, ActivityType, ActivityStatus
    speaker.dart                  # Speaker
    participant.dart              # Participant
    notification_item.dart        # NotificationItem + NotificationKind
    engagement.dart               # QaItem, Poll, PollOption
  data/
    mock_data.dart                # EventInfo + MockData (ponto único de dados)
  widgets/
    app_card.dart                 # cartão base (branco, borda, sombra)
    activity_card.dart            # cartão de sessão (destaque amber se EM CURSO)
    timeline_tile.dart            # linha do tempo da agenda
    type_chip.dart                # TypeLabel + LiveBadge ("EM CURSO")
    session_countdown.dart        # contador HH:MM:SS (modo claro/escuro)
    countdown.dart                # contador secundário
    home_banner.dart              # carrossel de imagens com auto-rotação
    image_banner.dart             # banner com imagem e véu escuro
    floating_nav.dart             # nav flutuante com FAB central (Mapa)
    app_drawer.dart               # menu lateral
    app_bar_actions.dart          # ações da AppBar
    brand_logo.dart               # BrandImage + AppAssets
  screens/
    splash_screen.dart            # abertura com anel orbital animado
    home_shell.dart               # estrutura de tabs + drawer
    home/home_screen.dart         # ecrã inicial
    agenda/agenda_screen.dart     # agenda dos 3 dias (linha do tempo)
    agenda/activity_detail_screen.dart  # detalhe (Oradores | Dúvidas)
    speakers/speakers_screen.dart
    ggpen/ggpen_screen.dart       # info sobre a GGPEN (separador 3)
    ggpen/location_screen.dart    # mapa/onde estamos
    my_agenda/my_agenda_screen.dart
    notifications/notifications_screen.dart
    participants/participants_screen.dart
    profile/profile_screen.dart
    admin/admin_screen.dart       # painel admin (reservado para futuro)
assets/
  logo_ggpen.png · logo_angotic.png
  banners/home.jpg · ggpen.jpg · perfil.jpg
```

Navegação principal (4 separadores + FAB):
`0 Início · 1 Agenda · [FAB Mapa] · 2 Oradores · 3 GGPEN`

---

## Funcionalidades implementadas

- **Ecrã inicial** com saudação, banner carrossel (auto-rotação 5s), card herói navy com contagem decrescente para a próxima sessão, destaque âmbar para sessões EM CURSO, acessos rápidos e programação de hoje.
- **Agenda** dos 3 dias do evento (11 Qui · 12 Sex · 13 Sáb), com linha do tempo, pesquisa por título/local/orador.
- **Detalhe da sessão** com banner, descrição, e duas abas: **Oradores** (cartões de oradores, com lookup automático de função/cor quando o nome coincide com a lista de oradores) e **Dúvidas** (Q&A funcional — utilizador escreve e envia, aparece em memória durante a sessão).
- **Minha agenda** com favoritos e lembretes (toggles persistidos localmente).
- **Notificações**, **Participantes**, **Perfil** (com login simples por nome + QR de crachá), **Mapa/Localização** do stand, **GGPEN** (página informativa institucional).
- **Splash screen** com animação orbital.
- **Persistência local** de favoritos, lembretes e nome do utilizador via `shared_preferences`.

---

## Sistema de design

Tudo em `lib/theme/app_theme.dart` e `lib/theme/app_colors.dart`.

**Cores (duotone)** — fundo claro + secções escuras navy:

| Token              | Valor       | Uso                                  |
| ------------------ | ----------- | ------------------------------------ |
| `navy`             | `#0E1B3D`   | textos/cabeçalhos, fundos de herói   |
| `techBlue`         | `#4D7EFF`   | acento principal (links, ações)      |
| `bg`               | `#F3F5F9`   | fundo da app                         |
| `line`             | `#E3E7F0`   | bordas e linhas subtis               |
| `live`             | `#E8920C`   | "EM CURSO" / destaque de ao vivo     |
| `talk/workshop/…`  | ver ficheiro | cores por categoria de atividade    |

**Tokens (em `AppTheme`)**:

```dart
// Espaçamento vertical
AppTheme.gap         // 8
AppTheme.labelGap    // 12  rótulo → conteúdo
AppTheme.cardGap     // 12  entre cartões numa lista
AppTheme.sectionGap  // 24  entre blocos/secções

// Ícones
AppTheme.iconMeta    // 14  ícones inline (hora, local)
AppTheme.iconSm      // 16  estados/avisos
AppTheme.iconAction  // 20  botões, atalhos, ações

// Estilos de texto
AppTheme.overline(color)                       // 11 / w800 / ls 1.1 (rótulos)
AppTheme.cardTitle({color, decoration})        // 15 / w700 / h 1.25
AppTheme.body(color)                           // 13 / h 1.4
AppTheme.meta(color)                           // 12
AppTheme.display(size, weight, color, height)  // títulos display
```

Usa sempre estes tokens em vez de números soltos para manter a consistência.

---

## Modelos de dados

`Activity` é o modelo central:

```dart
Activity(
  id: 'd1-market-intelligence',
  title: 'African Space Market Intelligence',
  description: '...',                 // opcional
  type: ActivityType.apresentacao,    // 7 categorias (ver activity.dart)
  day: 1,                              // 1 | 2 | 3
  start: DateTime, end: DateTime,
  location: 'Stand GGPEN',
  speaker: 'Dr. Temidayo Oniosun',    // string única, multi-oradores separados por " · "
  materials: [ActivityMaterial(...)], // opcional
  cancelled: false,
)
```

`ActivityType` (7 categorias) → cada uma com `label`, `color`, `icon` via extensão (`activity.dart`).
`ActivityStatus` calculado em runtime via `activity.statusAt(now)` → `upcoming | live | past | cancelled`.

Outros modelos: `Speaker`, `Participant`, `NotificationItem`, `QaItem`, `Poll`/`PollOption`.

---

## Mock data → integração com backend

**Tudo o que o backend deve substituir vive em `lib/data/mock_data.dart`.** Cada um destes é um candidato direto a endpoint da API:

| Atualmente                                | Origem (mock)                | Sugestão de endpoint                  |
| ----------------------------------------- | ---------------------------- | ------------------------------------- |
| Lista de actividades dos 3 dias           | `MockData.activities`        | `GET /events/angotic2026/activities`  |
| Rótulos de dia (data + dia da semana)     | `MockData.dayInfo`           | `GET /events/.../days`                |
| Avisos da organização                     | `MockData.notices`           | `GET /events/.../notices`             |
| Notificações                              | `MockData.notifications()`   | `GET /users/{id}/notifications`       |
| Oradores                                  | `MockData.speakers`          | `GET /events/.../speakers`            |
| Q&A da sessão (Dúvidas)                   | `MockData.qa` + estado local | `GET/POST /activities/{id}/questions` |
| Sondagem (componente removido do detalhe) | `MockData.poll`              | `GET /activities/{id}/poll`           |
| Participantes                             | `MockData.participants`      | `GET /events/.../participants`        |
| Info do evento (nome, subtítulo, stand)   | `EventInfo`                  | `GET /events/{id}`                    |

Notas importantes para a integração:
- `_t(day, h, m)` ancorou as horas a "hoje" + (day−1) para a **demo** funcionar com estados ao vivo em qualquer dia. **Em produção**, substituir por timestamps reais (ex.: `2026-06-11T13:45:00+01:00`) — o resto do código já trata `DateTime`.
- O `Activity.speaker` é uma `String` simples; ao ligar à API, é razoável passar a `List<Speaker>` com IDs. A aba **Oradores** já parte o speaker por `·` quando há vários (ver `_SpeakersTab` em `activity_detail_screen.dart`).
- As **Dúvidas** enviadas pelo utilizador vivem só em memória (`_QaTabState._mine`). Ligar `POST /questions` e re-fazer o fetch após submeter.

---

## Gestão de estado (`AppState`)

`lib/state/app_state.dart` — `ChangeNotifier` exposto via `Provider`:

```dart
state.userName              // String? (null quando não há sessão)
state.isLoggedIn
state.favorites             // Set<String> de IDs de atividades
state.isFavorite(id)
state.isReminder(id)
state.toggleFavorite(id)    // toggle + persistência
state.toggleReminder(id)    // marca lembrete (implica favorito)
state.login(name) / state.logout()
state.load()                // chamado no bootstrap (main.dart)
```

Persistido em `SharedPreferences` (chaves: `favorites`, `reminders`, `userName`).

---

## Comandos úteis

```bash
# Instalar dependências
flutter pub get

# Correr (web)
flutter run -d edge --web-port=8089

# Hot reload (no terminal): r       Hot restart: R       Sair: q
# Nunca recarregues o separador do navegador à mão durante o dev — usa r/R.

# Análise estática
flutter analyze

# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade
```

---

## O que continua em aberto

- Ligação a backend real (ver tabela em *Mock data → backend*).
- Implementação completa do **painel Admin** (`lib/screens/admin/admin_screen.dart` está reservado mas fora da navegação — ficheiro mantido como ponto de partida).
- Sondagem / poll na sessão (UI foi removida do detalhe, modelo `Poll`/`PollOption` continua disponível).
- Autenticação real (atualmente é só um nome guardado localmente).
- Push notifications reais (o ecrã de notificações lê mock).
- iOS/Desktop não estão configurados — adicionar com `flutter create . --platforms=ios,macos,windows,linux` se necessário.

---

## Notas de convenção

- Idioma: PT-PT/Angola em rótulos visíveis ("EM CURSO", "Próxima sessão começa em...").
- Ícones: usar **Lucide** (`lucide_icons_flutter`) — não misturar Material Icons.
- Logos: usar `BrandImage` com `AppAssets.ggpen` ou `AppAssets.angotic` (imagens já sem fundo).
- Banners: largar imagens em `assets/banners/` — a pasta está declarada no `pubspec`, novas imagens são incluídas automaticamente. Para juntar à rotação do banner inicial, acrescentar o caminho à lista `images` do `HomeBanner` em `home_screen.dart`.
- Tipografia/espaçamentos: usar os tokens de `AppTheme`. Evitar `fontSize` solto e `SizedBox` com números mágicos.
