import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/mock_data.dart';
import '../../models/activity.dart';
import '../../models/engagement.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/image_banner.dart';
import '../../widgets/type_chip.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
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
                const SnackBar(content: Text('Link copiado (demo)'))),
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
          // Abas
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _TabBtn('Oradores', 0, _tab, (i) => setState(() => _tab = i)),
                _TabBtn('Dúvidas', 1, _tab, (i) => setState(() => _tab = i)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [
                _SpeakersTab(activity: activity, muted: muted),
                _QaTab(muted: muted, userName: state.userName),
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
                  onChanged: (_) =>
                      context.read<AppState>().toggleReminder(activity.id),
                  secondary: Icon(isReminder
                      ? LucideIcons.bellRing
                      : LucideIcons.bell),
                  title: const Text('Lembrar-me antes de começar'),
                ),
              FilledButton.icon(
                onPressed: () =>
                    context.read<AppState>().toggleFavorite(activity.id),
                icon: Icon(isFav ? LucideIcons.check : LucideIcons.plus, size: 18),
                label: Text(isFav ? 'Na minha agenda' : 'Adicionar à minha agenda'),
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

  @override
  Widget build(BuildContext context) {
    final raw = activity.speaker?.trim() ?? '';
    if (raw.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Sem oradores associados a esta sessão.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: muted),
          ),
        ),
      );
    }
    final names = raw
        .split('·')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Text('ORADORES',
            style: AppTheme.overline(AppColors.navy.withValues(alpha: 0.45))),
        const SizedBox(height: 12),
        ...names.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SpeakerCard(
                  name: n, fallbackColor: activity.type.color, muted: muted),
            )),
      ],
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  final String name;
  final Color fallbackColor;
  final Color muted;
  const _SpeakerCard(
      {required this.name, required this.fallbackColor, required this.muted});

  @override
  Widget build(BuildContext context) {
    final matches = MockData.speakers.where((s) => s.name == name);
    final hasMatch = matches.isNotEmpty;
    final role = hasMatch ? matches.first.role : 'Orador convidado';
    final color = hasMatch ? matches.first.color : fallbackColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Text(_initialsOf(name),
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
                Text(name, style: AppTheme.cardTitle()),
                const SizedBox(height: 2),
                Text(role, style: AppTheme.meta(muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QaTab extends StatefulWidget {
  final Color muted;
  final String? userName;
  const _QaTab({required this.muted, required this.userName});

  @override
  State<_QaTab> createState() => _QaTabState();
}

class _QaTabState extends State<_QaTab> {
  final TextEditingController _controller = TextEditingController();
  final List<QaItem> _mine = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final name = widget.userName?.trim();
    final author = (name == null || name.isEmpty) ? 'Você' : name;
    setState(() {
      _mine.insert(
        0,
        QaItem(
          author: author,
          initials: _initialsOf(author),
          text: text,
          votes: 0,
          voted: false,
          time: 'agora',
        ),
      );
      _controller.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final muted = widget.muted;
    final items = [..._mine, ...MockData.qa];
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
                  hintText: 'Escreve a tua dúvida...',
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
                child:
                    const Icon(LucideIcons.send, size: 15, color: Colors.white),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        ...items.map((q) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _QaCard(item: q, muted: muted),
            )),
      ],
    );
  }
}

class _QaCard extends StatelessWidget {
  final QaItem item;
  final Color muted;
  const _QaCard({required this.item, required this.muted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: item.voted
                ? AppColors.techBlue.withValues(alpha: 0.25)
                : AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: item.initials.isEmpty
                  ? AppColors.navy.withValues(alpha: 0.12)
                  : AppColors.techBlue,
              child: item.initials.isEmpty
                  ? Icon(LucideIcons.user, size: 12, color: muted)
                  : Text(item.initials,
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 8),
            Text(item.author,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(item.time, style: TextStyle(fontSize: 10, color: muted)),
          ]),
          const SizedBox(height: 8),
          Text(item.text, style: const TextStyle(fontSize: 13, height: 1.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: item.voted
                  ? AppColors.techBlue.withValues(alpha: 0.15)
                  : AppColors.bg,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: item.voted
                      ? AppColors.techBlue.withValues(alpha: 0.3)
                      : AppColors.line),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(LucideIcons.thumbsUp,
                  size: 11,
                  color: item.voted ? AppColors.techBlue : muted),
              const SizedBox(width: 5),
              Text('${item.votes}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: item.voted ? AppColors.techBlue : muted)),
            ]),
          ),
        ],
      ),
    );
  }
}

