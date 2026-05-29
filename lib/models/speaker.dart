import 'package:flutter/material.dart';

class Speaker {
  final String name;
  final String role;
  final int sessions;
  final Color color;

  const Speaker({
    required this.name,
    required this.role,
    required this.sessions,
    required this.color,
  });

  String get initials {
    final parts = name.replaceAll(RegExp(r'(Eng\.|Dr\.|Dra\.|Prof\.)\s*'), '')
        .trim()
        .split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final p = parts.first;
      return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}
