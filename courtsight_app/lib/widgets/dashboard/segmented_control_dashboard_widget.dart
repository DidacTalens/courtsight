import 'package:flutter/material.dart';

class DashboardSegmentedControl extends StatelessWidget {
  const DashboardSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.cardColor,
    required this.accentColor,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color cardColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final double toggleWidth = (MediaQuery.of(context).size.width - 32) / 2 - 1.5;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ToggleButtons(
        isSelected: [selectedIndex == 0, selectedIndex == 1],
        onPressed: onSelected,
        color: Colors.grey,
        selectedColor: Colors.white,
        fillColor: accentColor,
        splashColor: accentColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.0),
        borderWidth: 0,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        constraints: BoxConstraints.tightFor(width: toggleWidth, height: 40),
        children: const [
          Text('En Curso / Próximos', style: TextStyle(fontWeight: FontWeight.w600)),
          Text('Finalizados', style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}