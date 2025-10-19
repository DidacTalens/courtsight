import 'package:flutter/material.dart';

import 'match_title_dashboard_widget.dart';

class DashboardMatchList extends StatelessWidget {
  const DashboardMatchList({
    super.key,
    required this.partidos,
    required this.cardColor,
    required this.accentColor,
  });

  final List<DashboardMatch> partidos;
  final Color cardColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (partidos.isEmpty) {
      return const Text(
        'No hay partidos disponibles.',
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: List.generate(
        partidos.length,
        (index) => DashboardMatchTile(
          partido: partidos[index],
          index: index,
          cardColor: cardColor,
          accentColor: accentColor,
        ),
      ),
    );
  }
}