# Agenda GGPEN — Angotic 2026

App Flutter da participação da **GGPEN** (Gabinete de Gestão do Programa Espacial Nacional de Angola) no **Angotic 2026** (Angola ICT Forum). Mostra a programação dos 3 dias do evento, as sessões a decorrer, a próxima sessão com contagem decrescente, os oradores convidados e permite aos participantes colocar dúvidas, gerir a sua agenda pessoal e receber lembretes locais.

---

## Estado do projeto

- **Front-end**: completo (UI, navegação, autenticação obrigatória, l10n PT/EN/FR/AR).
- **Backend**:
  - Agenda, oradores e dúvidas — ligados a **Supabase** via `lib/data/ggpen_repository.dart`.
  - Perfil manual (formulário de cadastro) — **apenas local** (`SharedPreferences`); sem backend.
- Pronto para entrega/uso real assim que a base Supabase estiver populada.

---

## Stack

- **Flutter** 3.19+ (Dart 3.3+) — testado em 3.44.0.
- **Provider** — gestão de estado.
- **supabase_flutter** — auth Google + dados da agenda/oradores/dúvidas.
- **shared_preferences** — favoritos, lembretes, idioma, perfil local.
- **flutter_localizations + intl** — PT/EN/FR/AR.
- **lucide_icons_flutter** — ícones (Lucide).
- **url_launcher** — abre URLs externos (site, email, redes sociais).
- **flutter_local_notifications + timezone** — lembretes locais agendados.
- **webview_flutter** — mapa 3D do recinto (venue map).
- **qr_flutter** — QR codes.
- **google_fonts** — disponível (atualmente usa-se a fonte do sistema).

Plataformas configuradas: **Web** e **Android**. iOS/macOS/Windows/Linux não estão configurados — criar via `flutter create . --platforms=ios,...` se necessário.

---

## Como correr

```bash
flutter pub get
flutter gen-l10n         # regenerar localizações (já corre dentro de pub get)

# Web (Edge / Chrome)
flutter run -d edge --web-port=8089
flutter run -d chrome

# Android (dispositivo ligado ou emulador)
flutter run -d <device-id>

# Análise estática
flutter analyze
```

Build de produção:

```bash
flutter build web                # /build/web
flutter build apk --release      # /build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release
```

**Configuração do Supabase**: chaves/URL geridas em `lib/data/ggpen_repository.dart` (e na inicialização em `lib/main.dart`). Para uso local sem Supabase configurado, o app continua a renderizar (mostra estados de erro), mas o login Google falha. O cadastro manual (formulário) **não depende de Supabase** e funciona sempre.

---

## Estrutura do projeto

```
lib/
  main.dart                       # bootstrap + Supabase.init + Provider AppState
  app.dart                        # MaterialApp + tema + locales
  l10n/                           # ARBs (pt, en, fr, ar) + código gerado
    app_pt.arb · app_en.arb · app_fr.arb · app_ar.arb
    app_localizations.dart        # GERADO
  state/
    app_state.dart                # estado global (Provider): sessão, perfil local, favoritos, locale
    event_state.dart              # fetch e cache da agenda/dias/oradores via repo
  data/
    ggpen_repository.dart         # acesso Supabase (auth, activities, speakers, qa, sessions)
    ggpen_models.dart             # modelos do backend (Activity, Speaker, Question, ...)
    mock_data.dart                # placeholders/fallback (EventInfo, alguns presets)
  models/
    activity.dart                 # Activity local + ActivityType (7 categorias) + statusAt
    speaker.dart                  # Speaker local (com sessions count, color, avatar)
    participant.dart
    notification_item.dart        # NotificationItem + NotificationKind
    engagement.dart               # QaItem, Poll, PollOption
  theme/
    app_colors.dart               # paleta duotone (navy + acentos + cores por categoria)
    app_theme.dart                # tokens (espaçamento, ícones, estilos) + ThemeData
  services/
    notification_service.dart     # flutter_local_notifications init + dispatch
    reminder_scheduler.dart       # agenda lembretes locais por sessão
  widgets/
    app_card.dart                 # cartão base (branco, borda, sombra, borderColor)
    activity_card.dart            # cartão de sessão (glow âmbar pulsante quando EM CURSO)
    timeline_tile.dart            # linha do tempo da agenda
    type_chip.dart                # TypeLabel + LiveBadge ("EM CURSO")
    session_countdown.dart        # contador HH:MM:SS (modo claro/escuro)
    countdown.dart                # contador secundário
    home_banner.dart              # carrossel de imagens com auto-rotação
    image_banner.dart             # banner com imagem e véu escuro
    floating_nav.dart             # nav flutuante com FAB central (Mapa) + labels
    app_drawer.dart               # menu lateral
    app_bar_actions.dart          # ações da AppBar
    brand_logo.dart               # BrandImage + AppAssets
    speaker_detail.dart           # modal centrado da ficha do orador
    promo_announcements.dart      # popup de anúncios (1:1, auto-close)
    data_status.dart              # LoadingView (skeleton) + ErrorView
    language_selector.dart        # picker de idioma
    contacts.dart                 # GgpenContacts + openExternalUrl + showSocialLinks
    venue_map/                    # mapa 3D do stand (webview)
  screens/
    splash_screen.dart            # abertura com anel orbital → AuthGate
    auth/
      auth_gate.dart              # Consumer: HomeShell se logged-in, senão LoginScreen
      login_screen.dart           # ecrã hero com fundo perfil.jpg + 2 CTAs (Google / email)
      signup_screen.dart          # form de cadastro: nome/email/telefone/empresa/cargo + termos
    home_shell.dart               # estrutura de tabs + drawer
    home/home_screen.dart         # home (banner, live, countdown, atalhos, programação)
    agenda/agenda_screen.dart     # agenda dos 3 dias (linha do tempo)
    agenda/activity_detail_screen.dart  # detalhe da sessão (Oradores | Dúvidas)
    speakers/speakers_screen.dart # grelha de oradores
    ggpen/ggpen_screen.dart       # página GGPEN (separador 3)
    ggpen/location_screen.dart    # mapa do stand
    my_agenda/my_agenda_screen.dart
    notifications/notifications_screen.dart
    participants/participants_screen.dart
    profile/profile_screen.dart   # perfil + logout (login antigo removido)
    admin/admin_screen.dart       # reservado para futuro painel admin (fora da nav)
assets/
  logo_ggpen.png · logo_angotic.png
  banners/home.jpg · ggpen.jpg · perfil.jpg
  promo1.png · promo2.png
  venue/venue_map.html · three.min.js
```

Navegação inferior (4 separadores + FAB):
`0 Início · 1 Agenda · [FAB Mapa] · 2 Oradores · 3 GGPEN`

---

## Autenticação (obrigatória)

A app exige sessão para chegar à `HomeShell`. O fluxo é decidido por `AuthGate`:

```
SplashScreen ─► AuthGate ─► HomeShell        (se isLoggedIn)
                         └► LoginScreen      (se NÃO isLoggedIn)
```

**Duas formas** de iniciar sessão:

1. **Google (Supabase OAuth)** — botão "Continuar com Google" no `LoginScreen`. Cria sessão real em `supabase_flutter` (`signInWithGoogle()`). Reage automaticamente a `authChanges`.
2. **Cadastro manual** — `SignupScreen` com formulário: **nome, email, telefone, empresa, cargo** + checkbox de **termos** (com modal completo que menciona o uso de dados, incluindo conteúdos publicitários e de marketing). Persistido **apenas localmente** em `SharedPreferences` via `AppState.signUpLocal(...)`.

A propriedade `AppState.isLoggedIn` retorna `true` quando há **sessão Google OU perfil local**. O `signOut()` limpa ambos.

Para terminar sessão: ecrã **Perfil** → botão "Terminar sessão". O `AuthGate` redireciona automaticamente para o `LoginScreen`.

---

## Funcionalidades implementadas

**Home**
- Logo GGPEN centrada com barra de gradiente da marca + saudação personalizada.
- **Banner** carrossel auto-rotativo (5s) com imagens de `assets/banners/`.
- **Card "A decorrer agora"** com glow âmbar pulsante (`AppColors.live`).
- **Card "Próxima sessão"** em herói navy com cronómetro centrado HH:MM:SS; quando faltam < 5 min, ganha **estado de urgência** (overline âmbar + ponto + sombra âmbar pulsante).
- **Badge do sino** com contagem real de notificações não-lidas.
- Atalhos **Guardadas** e **Avisos**.
- Lista das próximas sessões de hoje.

**Agenda**
- 3 dias (11 Qui · 12 Sex · 13 Sáb) com linha do tempo, pesquisa por título/local/orador.

**Detalhe da sessão**
- Cabeçalho com banner, categoria, hora e local.
- **2 abas**: **Oradores** (cartões com avatar + nome + nº de sessões, toque abre modal) e **Dúvidas** (Q&A funcional — utilizador envia, aparece na lista em memória).
- Botão de **guardar** (marcador rounded preenchido em azul tech) na AppBar.
- Descrição da sessão (quando existe) entre cabeçalho e abas.

**Outros ecrãs**
- **Oradores**: grelha 2 colunas, cartão com avatar + nome + chip de sessões; tap abre modal.
- **Minha Agenda**: sessões marcadas como favoritas + toggle de lembrete.
- **Notificações**: dinâmicas a partir das sessões (live + a começar em breve + boas-vindas).
- **GGPEN**: página institucional com banner, logo centrada, descrição correta, links para agenda/mapa, contactos e redes sociais.
- **Mapa**: webview com modelo 3D do stand (three.js).
- **Perfil**: nome, email da sessão, contadores (favoritos/lembretes), idioma, antecedência do lembrete, logout.

**UX transversal**
- **Skeleton loaders** (placeholders pulsantes) em vez de spinner.
- **Modais centrados**:
  - Ficha do orador com header em gradiente da cor da categoria.
  - Popup de anúncios com moldura **1:1 fixa** (`BoxFit.cover`) e **barra de progresso** do auto-close.
- **L10n** completa em PT / EN / FR / AR.
- **Nav flutuante** com micro-labels por baixo dos ícones.

---

## Sistema de design

Tudo em `lib/theme/app_theme.dart` e `lib/theme/app_colors.dart`.

**Cores (duotone)** — fundo claro + secções escuras navy:

| Token             | Valor       | Uso                                  |
| ----------------- | ----------- | ------------------------------------ |
| `navy`            | `#0E1B3D`   | texto, fundos de herói               |
| `techBlue`        | `#4D7EFF`   | acento principal (links, ações)      |
| `bg`              | `#F3F5F9`   | fundo da app                         |
| `line`            | `#E3E7F0`   | bordas subtis                        |
| `live`            | `#E8920C`   | "EM CURSO" / urgência                |
| `talk/workshop/…` | ver ficheiro | cores por categoria de actividade   |
| `brandGradient`   | gradiente   | acento de marca (splash, separadores) |

**Tokens (em `AppTheme`)**

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
AppTheme.overline(color)                       // 11 / w800 / ls 1.1
AppTheme.cardTitle({color, decoration})        // 15 / w700 / h 1.25
AppTheme.body(color)                           // 13 / h 1.4
AppTheme.meta(color)                           // 12
AppTheme.display(size, weight, color, height)  // títulos display
```

Usar sempre os tokens em vez de números soltos.

---

## Modelos de dados

`Activity` (local) é o modelo central da UI:

```dart
Activity(
  id: 'd1-market-intelligence',
  title: 'African Space Market Intelligence',
  description: '...',                 // opcional
  type: ActivityType.apresentacao,    // 7 categorias
  day: 1,                              // 1 | 2 | 3
  start: DateTime, end: DateTime,
  location: 'Stand GGPEN',
  speaker: 'Dr. Temidayo Oniosun',    // multi-oradores separados por " · "
  materials: [ActivityMaterial(...)], // opcional
  cancelled: false,
)
```

`ActivityType` (7 categorias) → cada uma com `label()` (l10n), `color`, `icon` via extensão.
`ActivityStatus` calculado em runtime via `activity.statusAt(now)` → `upcoming | live | past | cancelled`.

Outros: `Speaker`, `Participant`, `NotificationItem`, `QaItem`, `Poll`/`PollOption`.

Modelos do backend Supabase em `lib/data/ggpen_models.dart` (importados com `as sb`): `sb.Activity`, `sb.Speaker`, `sb.Question`, etc.

---

## Camada de dados

| Origem                      | Fonte                                       | Estado     |
| --------------------------- | ------------------------------------------- | ---------- |
| Activities / dias           | Supabase (`GgpenRepository.getActivities`)  | Ligado     |
| Speakers (todos)            | Supabase (`getSpeakers`)                    | Ligado     |
| Speakers por sessão         | Supabase (`getSpeakers(sessionId)`)         | Ligado     |
| Sessões de um orador        | Supabase (`getSpeakerSessions(speakerId)`)  | Ligado     |
| Q&A (Dúvidas)               | Supabase + memória local (envio imediato)   | Ligado     |
| Notificações                | Derivadas localmente das actividades        | Local      |
| Participantes               | `MockData.participants` (placeholder)       | Mock       |
| Perfil manual (cadastro)    | `SharedPreferences`                         | Local      |
| Favoritos + lembretes       | `SharedPreferences`                         | Local      |
| Idioma                      | `SharedPreferences`                         | Local      |

A `EventState` faz `repo.getActivities()` no arranque e gere `LoadStatus` (loading/ready/error) para alimentar os `LoadingView` e `ErrorView` em qualquer ecrã que precise.

---

## Gestão de estado (`AppState`)

`lib/state/app_state.dart` — `ChangeNotifier` exposto via `Provider`:

```dart
// Sessão (Google OU perfil local)
state.isLoggedIn        // true se Google session OU localProfile != null
state.userName          // Google profile name OU localProfile['name']
state.userEmail         // Google email OU localProfile['email']
state.localProfile      // Map<String, String>? com name/email/phone/company/role

// Auth
state.signInWithGoogle()
state.signUpLocal(name:, email:, phone:, company:, role:)
state.signOut()         // limpa Google + local

// Favoritos e lembretes
state.favorites, isFavorite(id), toggleFavorite(id)
state.isReminder(id), toggleReminder(id)

// Preferências
state.locale, setLocale(Locale?)
state.reminderLeadMinutes, setReminderLeadMinutes(int)

// Bootstrap
state.load()            // chamado em main.dart
```

Persistido em `SharedPreferences` (chaves: `favorites`, `reminders`, `userName`, `locale`, `reminderLeadMinutes`, `localProfile` em JSON).

`EventState` (separado, em `lib/state/event_state.dart`) cuida da agenda/oradores via `GgpenRepository` com loading/error.

---

## Localização (i18n)

ARBs em `lib/l10n/`:

- `app_pt.arb` (primária para Angola)
- `app_en.arb` (template — Flutter `template-arb-file: app_en.arb`)
- `app_fr.arb`
- `app_ar.arb` (RTL)

Para adicionar uma chave:

1. Editar o ARB de cada idioma (acrescentar a chave nova).
2. `flutter pub get` regenera `app_localizations.dart` automaticamente (ou `flutter gen-l10n`).
3. Usar `AppLocalizations.of(context).<chave>` no widget.

Chaves chave para o fluxo de auth: `authWelcomeTitle`, `authContinueWithGoogle`, `authCreateAccount`, `signupTitle`, `signupNameLabel` (+ email, phone, company, role), `signupTermsPrefix/Link/Suffix`, `termsDialogTitle`, `termsBody`, `signupHaveAccount`, `signupSignInLink`.

---

## Comandos úteis

```bash
flutter pub get                       # instala deps + regenera l10n
flutter gen-l10n                      # apenas regenera l10n
flutter run -d edge --web-port=8089   # web

# No terminal do flutter run:
#   r  -> hot reload (não apanha l10n regenerado)
#   R  -> hot restart (apanha código gerado)
#   q  -> sair

flutter analyze                       # análise estática
flutter clean                         # limpar build (depois pub get)
flutter pub upgrade                   # atualizar deps
```

---

## O que continua em aberto

- **Painel Admin** — `lib/screens/admin/admin_screen.dart` mantido como base, fora da nav. Implementação pendente.
- **Login com email/password real** — sem backend para isso; o "Entrar" do `SignupScreen` reencaminha para o `LoginScreen` (Google é o caminho real).
- **Notificações push** reais (atualmente são locais via `flutter_local_notifications`).
- **iOS/Desktop** — adicionar com `flutter create . --platforms=ios,macos,windows,linux` se necessário.
- **Página GGPEN mais rica** — atualmente texto + links + contactos.

---

## Notas de convenção

- Idioma: **PT-PT/Angola** em rótulos (a app é multilingue PT/EN/FR/AR).
- Ícones: **Lucide** (`lucide_icons_flutter`); só `Icons.bookmark_rounded` (Material) é usado pontualmente para o estado preenchido do favorito (Lucide não tem variante preenchida).
- Logos: `BrandImage` com `AppAssets.ggpen` / `AppAssets.angotic`.
- Banners: largar imagens em `assets/banners/` — a pasta está declarada no `pubspec`. Para juntar à rotação do banner inicial, acrescentar à lista `images` em [home_screen.dart](lib/screens/home/home_screen.dart) (`HomeBanner`).
- **Promo / anúncios**: usar **1080×1080** (1:1, JPG ou PNG ≤ 500 KB), conteúdo importante centrado.
- **Banners da home**: usar **1600×900** (16:9).
- **Logos**: PNG transparente, ~300–500 px de altura.
- **Avatares de orador (futuro `avatarUrl`)**: quadrado, mínimo 400×400.
- Tipografia/espaçamentos: usar os tokens de `AppTheme`. Evitar `fontSize` solto e `SizedBox` com números mágicos.
