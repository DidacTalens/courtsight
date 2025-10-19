import 'package:flutter/material.dart';

class DashboardConfigTeamCard extends StatelessWidget {
  const DashboardConfigTeamCard({
    super.key,
    required this.cardColor,
    required this.accentColor,
    this.onTap,
  });

  final Color cardColor;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap ?? _defaultOnTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.people_alt, color: accentColor, size: 30),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configurar mi equipo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Define la configuración de tu equipo local',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _defaultOnTap() {
    // TODO: Implementar navegación a la edición del Equipo Local
    debugPrint('Navegar a Editar Equipo Local');
  }
}