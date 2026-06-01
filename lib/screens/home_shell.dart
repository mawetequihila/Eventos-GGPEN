import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/floating_nav.dart';
import '../widgets/promo_announcements.dart';
import 'agenda/agenda_screen.dart';
import 'ggpen/ggpen_screen.dart';
import 'ggpen/location_screen.dart';
import 'home/home_screen.dart';
import 'my_agenda/my_agenda_screen.dart';
import 'notifications/notifications_screen.dart';
import 'participants/participants_screen.dart';
import 'profile/profile_screen.dart';
import 'speakers/speakers_screen.dart';

/// Estrutura principal: nav flutuante (Início, Agenda, [Mapa], Oradores, GGPEN)
/// + menu lateral com todas as secções.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  // Anúncios GGPEN: aparecem de tempo em tempo, em qualquer aba.
  Timer? _promoTimer;
  int _promoIndex = 0;
  bool _promoOpen = false;
  static const Duration _promoFirstDelay = Duration(seconds: 30);
  // Troca de anúncio a cada 2,5 min; cada um fica visível 1 min.
  static const Duration _promoInterval = Duration(seconds: 150);
  static const Duration _promoDuration = Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    Future.delayed(_promoFirstDelay, () {
      if (!mounted) return;
      _showPromo();
      _promoTimer = Timer.periodic(_promoInterval, (_) => _showPromo());
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    super.dispose();
  }

  Future<void> _showPromo() async {
    if (!mounted || _promoOpen) return;
    const posts = PromoAnnouncements.posts;
    if (posts.isEmpty) return;
    final asset = posts[_promoIndex % posts.length];
    _promoIndex++;
    _promoOpen = true;
    await showPromoSheet(context, asset, autoClose: _promoDuration);
    _promoOpen = false;
  }

  void _goTab(int i) => setState(() => _index = i);
  void _openMenu() => _scaffoldKey.currentState?.openDrawer();

  void _push(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _agendaFromPushed() {
    Navigator.of(context).popUntil((r) => r.isFirst);
    _goTab(1);
  }

  void _openMinha() =>
      _push(MyAgendaScreen(onOpenAgenda: _agendaFromPushed));
  void _openNotif() => _push(const NotificationsScreen());
  void _openMapa() => _push(const LocationScreen());
  void _openPerfil() => _push(const ProfileScreen());
  void _openParticipantes() => _push(const ParticipantsScreen());

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        onMenu: _openMenu,
        onOpenAgenda: () => _goTab(1),
        onOpenSaved: _openMinha,
        onOpenMap: _openMapa,
        onOpenNotifications: _openNotif,
      ),
      AgendaScreen(onMenu: _openMenu),
      SpeakersScreen(onMenu: _openMenu),
      GgpenScreen(onMenu: _openMenu, onOpenAgenda: () => _goTab(1)),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        selectedIndex: _index,
        onSelectTab: _goTab,
        onOpenMinha: _openMinha,
        onOpenNotif: _openNotif,
        onOpenMapa: _openMapa,
        onOpenParticipantes: _openParticipantes,
        onOpenPerfil: _openPerfil,
      ),
      body: pages[_index],
      bottomNavigationBar: FloatingNav(
        selectedIndex: _index,
        onSelect: _goTab,
        onFab: _openMapa,
      ),
    );
  }
}
