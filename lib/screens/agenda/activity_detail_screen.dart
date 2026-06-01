import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/ggpen_models.dart' as sb;
import '../../data/ggpen_repository.dart';
import '../../models/activity.dart';
import '../../models/speaker.dart';
import '../../services/notification_service.dart';
import '../../services/reminder_scheduler.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/data_status.dart';
import '../../widgets/image_banner.dart';
import '../../widgets/speaker_detail.dart';
import '../../widgets/type_chip.dart';
import '../ggpen/location_screen.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  int _tab = 0;

  /// Alterna o lembrete e agenda/cancela a notificação local (telemóvel),
  /// para tocar ~10 min antes da sessão começar.
  void _toggleReminder() {
    final state = context.read<AppState>();
    final l = AppLocalizations.of(context);
    final a = widget.activity;
    state.toggleReminder(a.id);
    if (state.isReminder(a.id)) {
      scheduleReminderFor(l, a, state.reminderLeadMinutes);
    } else {
      NotificationService.instance.cancelReminder(a.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final activity = widget.activity;
    final muted = AppColors.navy.withValues(alpha: 0.6);
    final state = context.watch<AppState>();
    final isFav = state.isFavorite(activity.id);
    final isReminder = state.isReminder(activity.id);
    final status = activity.statusAt(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bookmark,
                color: isFav ? AppColors.gold : Colors.white),
            onPressed: () => context.read<AppState>().toggleFavorite(activity.id),
          ),
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.linkCopied))),
          ),
        ],
      ),
      body: Column(
        children: [
          ImageBanner(
            borderRadius: BorderRadius.zero,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  TypeLabel(activity.type),
                  const SizedBox(width: 10),
                  if (status == ActivityStatus.live) const LiveBadge(),
                ]),
                const SizedBox(height: 10),
                Text(activity.title,
                    style: AppTheme.display(size: 21, color: Colors.white)),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(LucideIcons.clock, size: 12, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(activity.timeRange,
                      style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(width: 14),
                  const Icon(LucideIcons.mapPin, size: 12, color: Colors.white70),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(activity.location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ),
                ]),
              ],
            ),
          ),
          if (activity.description.trim().isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                activity.description,
                style: TextStyle(fontSize: 14, height: 1.55, color: muted),
              ),
            ),
          if (activity.location.trim().isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: _LocationTile(location: activity.location),
            ),
          // Abas — Fotos primeiro (aberto por defeito).
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _TabBtn(l.photosTitle, 0, _tab, (i) => setState(() => _tab = i)),
                _TabBtn(l.tabSpeakers, 1, _tab, (i) => setState(() => _tab = i)),
                _TabBtn(l.tabQa, 2, _tab, (i) => setState(() => _tab = i)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                _PhotosTab(activityId: activity.id, muted: muted),
                _SpeakersTab(activity: activity, muted: muted),
                _QaTab(activityId: activity.id, muted: muted),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isFav)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isReminder,
                  onChanged: (_) => _toggleReminder(),
                  secondary: Icon(isReminder
                      ? LucideIcons.bellRing
                      : LucideIcons.bell),
                  title: Text(l.remindBeforeStart),
                ),
              FilledButton.icon(
                onPressed: () =>
                    context.read<AppState>().toggleFavorite(activity.id),
                icon: Icon(isFav ? LucideIcons.check : LucideIcons.plus, size: 18),
                label: Text(isFav ? l.inMyAgenda : l.addToMyAgenda),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;
  const _TabBtn(this.label, this.index, this.current, this.onTap);

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.techBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.techBlue : AppColors.navy.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }
}

String _initialsOf(String name) {
  final p = name.trim().split(RegExp(r'\s+'));
  if (p.isEmpty || p.first.isEmpty) return '?';
  if (p.length == 1) {
    return p.first.substring(0, p.first.length >= 2 ? 2 : 1).toUpperCase();
  }
  return (p.first[0] + p.last[0]).toUpperCase();
}

class _SpeakersTab extends StatelessWidget {
  final Activity activity;
  final Color muted;
  const _SpeakersTab({required this.activity, required this.muted});

  static const List<Color> _palette = [
    AppColors.talk,
    AppColors.demo,
    AppColors.ceremony,
    AppColors.workshop,
    AppColors.navy,
    Color(0xFF2A4A8C),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<GgpenRepository>();
    return FutureBuilder<List<sb.Speaker>>(
      future: repo.getSpeakers(activity.id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        }
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(l.loadError,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: muted)),
            ),
          );
        }
        final speakers = snap.data ?? const <sb.Speaker>[];
        if (speakers.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                l.noSpeakersForSession,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: muted),
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          children: [
            Text(l.speakersUpper,
                style:
                    AppTheme.overline(AppColors.navy.withValues(alpha: 0.45))),
            const SizedBox(height: 12),
            for (var i = 0; i < speakers.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SpeakerCard(
                  speaker: speakers[i],
                  color: _palette[i % _palette.length],
                  muted: muted,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  final sb.Speaker speaker;
  final Color color;
  final Color muted;
  const _SpeakerCard(
      {required this.speaker, required this.color, required this.muted});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final org = speaker.organizacao?.trim() ?? '';
    final base = org.isEmpty ? l.guestSpeaker : org;
    final role = speaker.papel == 'moderador' ? '${l.moderator} · $base' : base;
    final hasPhoto = (speaker.avatarUrl ?? '').isNotEmpty;

    void openDetail() => showSpeakerDetail(
          context,
          Speaker(
            id: speaker.id,
            name: speaker.nome,
            role: org,
            bio: speaker.bio,
            avatarUrl: speaker.avatarUrl,
            sessions: 0,
            color: color,
          ),
        );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: openDetail,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color,
                backgroundImage: hasPhoto ? NetworkImage(speaker.avatarUrl!) : null,
                child: hasPhoto
                    ? null
                    : Text(_initialsOf(speaker.nome),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(speaker.nome, style: AppTheme.cardTitle()),
                    const SizedBox(height: 2),
                    Text(role, style: AppTheme.meta(muted)),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight,
                  size: 18, color: AppColors.navy.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final String location;
  const _LocationTile({required this.location});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: AppColors.bg,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => LocationScreen(destination: location)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.techBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.mapPin,
                    color: AppColors.techBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.locationSection.toUpperCase(),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.navy.withValues(alpha: 0.45))),
                    const SizedBox(height: 2),
                    Text(location,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight,
                  size: 20, color: AppColors.navy.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotosTab extends StatelessWidget {
  final String activityId;
  final Color muted;
  const _PhotosTab({required this.activityId, required this.muted});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final repo = context.read<GgpenRepository>();
    return FutureBuilder<List<String>>(
      future: repo.getActivityPhotos(activityId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        }
        final photos = snap.data ?? const <String>[];
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(l.loadError,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: muted)),
            ),
          );
        }
        if (photos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.image, size: 40, color: muted),
                  const SizedBox(height: 12),
                  Text(l.noPhotos,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: muted)),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: photos.length,
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.black,
              pageBuilder: (_, __, ___) => _PhotoViewer(
                  photos: photos, initialIndex: i, heroPrefix: activityId),
            )),
            child: Hero(
              tag: 'photo-$activityId-$i',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  photos[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.line,
                    child: Icon(LucideIcons.imageOff, color: muted),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Visualizador de fotos em ecrã inteiro: zoom (pinça/duplo toque), deslize
/// entre fotos e toque/fechar para sair.
class _PhotoViewer extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  final String heroPrefix;
  const _PhotoViewer({
    required this.photos,
    required this.initialIndex,
    required this.heroPrefix,
  });

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.photos.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Center(
                child: Hero(
                  tag: 'photo-${widget.heroPrefix}-$i',
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Image.network(
                      widget.photos[i],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                          LucideIcons.imageOff,
                          color: Colors.white54,
                          size: 48),
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white54)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Barra superior: fechar + contador.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  if (widget.photos.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        '${_index + 1}/${widget.photos.length}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _relativeTime(AppLocalizations l, DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.isNegative || diff.inMinutes < 1) return l.relativeNow;
  if (diff.inMinutes < 60) return l.relativeMinutes(diff.inMinutes);
  if (diff.inHours < 24) return l.relativeHours(diff.inHours);
  return l.relativeDays(diff.inDays);
}

class _QaTab extends StatefulWidget {
  final String activityId;
  final Color muted;
  const _QaTab({required this.activityId, required this.muted});

  @override
  State<_QaTab> createState() => _QaTabState();
}

class _QaTabState extends State<_QaTab> {
  final TextEditingController _controller = TextEditingController();
  final GgpenRepository _repo = GgpenRepository();
  StreamSubscription<List<sb.Question>>? _sub;

  List<sb.Question> _questions = [];
  Set<String> _liked = {};
  String? _myId;
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    // Tempo real: quando o admin aprova uma dúvida, a lista atualiza-se.
    _sub = _repo
        .watchApprovedQuestions(widget.activityId)
        .listen((_) => _refresh());
    _refresh();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Recarrega as dúvidas aprovadas (com contagem de gostos) e os gostos do
  /// utilizador. A stream da tabela não traz a contagem, por isso usamos a view.
  Future<void> _refresh() async {
    try {
      final approved = await _repo.getApprovedQuestions(widget.activityId);
      final liked = await _repo.getLikedQuestionIds();
      final mine = await _repo.getMyQuestions(widget.activityId);
      final approvedIds = approved.map((q) => q.id).toSet();
      // As próprias ainda pendentes — visíveis só para o autor, com etiqueta.
      final ownPending = mine
          .where((q) => q.status == 'pending' && !approvedIds.contains(q.id))
          .toList();
      if (!mounted) return;
      setState(() {
        _questions = [...ownPending, ...approved];
        _liked = liked;
        _myId = _repo.currentUser?.id;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _requireLogin(AppLocalizations l, ScaffoldMessengerState m) async {
    m.showSnackBar(SnackBar(content: Text(l.qaLoginRequired)));
    await context.read<AppState>().signInWithGoogle();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_repo.isLoggedIn) {
      await _requireLogin(l, messenger);
      return;
    }
    setState(() => _sending = true);
    try {
      await _repo.submitQuestion(activityId: widget.activityId, texto: text);
      _controller.clear();
      if (mounted) FocusScope.of(context).unfocus();
      messenger.showSnackBar(SnackBar(content: Text(l.qaSentPending)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _toggleLike(String questionId) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!_repo.isLoggedIn) {
      await _requireLogin(l, messenger);
      return;
    }
    try {
      await _repo.toggleLike(questionId);
      await _refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _edit(sb.Question q) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final controller = TextEditingController(text: q.texto);
    final newText = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.qaEditTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 1,
          maxLines: 4,
          decoration: InputDecoration(hintText: l.qaHint),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: Text(l.cancel)),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(l.qaSave),
          ),
        ],
      ),
    );
    if (newText == null || newText.isEmpty || newText == q.texto) return;
    try {
      await _repo.updateMyQuestion(q.id, newText);
      await _refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _delete(sb.Question q) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.qaDeleteConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l.cancel)),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: const Color(0xFFE5484D)),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.qaDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _repo.deleteMyQuestion(q.id);
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.qaDeleted)));
      }
      await _refresh();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = widget.muted;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: l.qaHint,
                  hintStyle: TextStyle(fontSize: 13, color: muted),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _submit,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                    color: AppColors.techBlue, shape: BoxShape.circle),
                child: _sending
                    ? const Padding(
                        padding: EdgeInsets.all(9),
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(LucideIcons.send,
                        size: 15, color: Colors.white),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: AppColors.techBlue),
              ),
            ),
          )
        else if (_questions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(l.noQuestionsYet,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: muted)),
            ),
          )
        else
          ..._questions.map((q) {
            final isMine = _myId != null && q.autorId == _myId;
            final isPending = q.status != 'approved';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _QaCard(
                question: q,
                voted: _liked.contains(q.id),
                relative: _relativeTime(l, q.createdAt),
                muted: muted,
                isPending: isPending,
                onLike: () => _toggleLike(q.id),
                // Editar só enquanto pendente; eliminar sempre (é dono).
                onEdit: isMine && isPending ? () => _edit(q) : null,
                onDelete: isMine ? () => _delete(q) : null,
              ),
            );
          }),
      ],
    );
  }
}

class _QaCard extends StatelessWidget {
  final sb.Question question;
  final bool voted;
  final String relative;
  final Color muted;
  final bool isPending;
  final VoidCallback onLike;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const _QaCard({
    required this.question,
    required this.voted,
    required this.relative,
    required this.muted,
    required this.isPending,
    required this.onLike,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final author = question.autorNome?.trim() ?? '';
    final initials = author.isEmpty ? '' : _initialsOf(author);
    final isMine = onDelete != null;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: voted
                ? AppColors.techBlue.withValues(alpha: 0.25)
                : AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: initials.isEmpty
                  ? AppColors.navy.withValues(alpha: 0.12)
                  : AppColors.techBlue,
              child: initials.isEmpty
                  ? Icon(LucideIcons.user, size: 12, color: muted)
                  : Text(initials,
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(author,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            if (isPending) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(l.qaPending,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning)),
              ),
            ],
            const Spacer(),
            Text(relative, style: TextStyle(fontSize: 10, color: muted)),
            if (isMine)
              SizedBox(
                height: 22,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  icon: Icon(LucideIcons.moreVertical, color: muted),
                  onSelected: (v) {
                    if (v == 'edit') onEdit?.call();
                    if (v == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    if (onEdit != null)
                      PopupMenuItem(value: 'edit', child: Text(l.qaEdit)),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(l.qaDelete,
                          style: const TextStyle(color: Color(0xFFE5484D))),
                    ),
                  ],
                ),
              ),
          ]),
          const SizedBox(height: 8),
          Text(question.texto,
              style: const TextStyle(fontSize: 13, height: 1.5)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onLike,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: voted
                    ? AppColors.techBlue.withValues(alpha: 0.15)
                    : AppColors.bg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: voted
                        ? AppColors.techBlue.withValues(alpha: 0.3)
                        : AppColors.line),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(LucideIcons.thumbsUp,
                    size: 11, color: voted ? AppColors.techBlue : muted),
                const SizedBox(width: 5),
                Text('${question.likes}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: voted ? AppColors.techBlue : muted)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

