import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../data/mock_data.dart';
import '../../models/activity.dart';
import '../../theme/app_colors.dart';
import '../../widgets/timeline_tile.dart';
import 'activity_detail_screen.dart';

class AgendaScreen extends StatefulWidget {
  final VoidCallback onMenu;
  const AgendaScreen({super.key, required this.onMenu});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  int _day = 1;

  @override
  Widget build(BuildContext context) {
    final items = MockData.byDay(_day);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, size: 20),
          onPressed: widget.onMenu,
        ),
        title: const Text('Agenda'),
        actions: [
          IconButton(
            tooltip: 'Procurar',
            icon: const Icon(LucideIcons.search, size: 20),
            onPressed: () => showSearch(
              context: context,
              delegate: _ActivitySearchDelegate(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                for (var d = 1; d <= 3; d++) ...[
                  Expanded(child: _DayPill(day: d, selected: _day == d, onTap: () => setState(() => _day = d))),
                  if (d < 3) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: items.length,
              itemBuilder: (context, i) => TimelineTile(
                activity: items[i],
                isFirst: i == 0,
                isLast: i == items.length - 1,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActivityDetailScreen(activity: items[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  final int day;
  final bool selected;
  final VoidCallback onTap;
  const _DayPill({required this.day, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.navy : Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.navy : AppColors.line),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  MockData.dayInfo[day]!.weekday,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white.withValues(alpha: 0.85)
                        : AppColors.navy.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  MockData.dayInfo[day]!.date,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivitySearchDelegate extends SearchDelegate<Activity?> {
  @override
  String get searchFieldLabel => 'Procurar actividade, local ou orador';

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(LucideIcons.x),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(LucideIcons.arrowLeft),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return const Center(child: Text('Escreve para procurar…'));
    }
    final results = MockData.activities.where((a) {
      return a.title.toLowerCase().contains(q) ||
          a.location.toLowerCase().contains(q) ||
          (a.speaker?.toLowerCase().contains(q) ?? false);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text('Nenhum resultado.'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final a = results[i];
        return ListTile(
          leading: Icon(a.type.icon, color: a.type.color, size: 20),
          title: Text(a.title),
          subtitle: Text('Dia ${a.day} · ${a.timeRange} · ${a.location}'),
          onTap: () {
            close(context, a);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ActivityDetailScreen(activity: a),
              ),
            );
          },
        );
      },
    );
  }
}
