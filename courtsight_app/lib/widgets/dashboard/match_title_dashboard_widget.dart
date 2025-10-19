import 'package:flutter/material.dart';

enum DashboardMatchEstado { enCurso, proximo, finalizado }

class DashboardMatch {
  const DashboardMatch({
    required this.id,
    required this.nombreLocal,
    required this.nombreVisitante,
    required this.marcador,
    required this.estado,
    required this.fechaHora,
  });

  final String id;
  final String nombreLocal;
  final String nombreVisitante;
  final String marcador;
  final DashboardMatchEstado estado;
  final String fechaHora;
}

const List<DashboardMatch> demoDashboardMatches = [
  DashboardMatch(
    id: 'p001',
    nombreLocal: 'Equipo Local',
    nombreVisitante: 'Equipo Visitante',
    marcador: '24 - 21. En Curso, 2ª Mitad',
    estado: DashboardMatchEstado.enCurso,
    fechaHora: 'Hoy, 19:30',
  ),
  DashboardMatch(
    id: 'p002',
    nombreLocal: 'Otro Equipo',
    nombreVisitante: 'Equipo Demo',
    marcador: '',
    estado: DashboardMatchEstado.proximo,
    fechaHora: '28 NOV, 18:00',
  ),
  DashboardMatch(
    id: 'p003',
    nombreLocal: 'Equipo Casa',
    nombreVisitante: 'Visitante Fuerte',
    marcador: '18 - 22',
    estado: DashboardMatchEstado.finalizado,
    fechaHora: 'Ayer, 20:00',
  ),
  DashboardMatch(
    id: 'p004',
    nombreLocal: 'Club B',
    nombreVisitante: 'Club A',
    marcador: '30 - 25',
    estado: DashboardMatchEstado.finalizado,
    fechaHora: '1 NOV, 19:00',
  ),
];

class DashboardMatchTile extends StatelessWidget {
  const DashboardMatchTile({
    super.key,
    required this.partido,
    required this.index,
    required this.cardColor,
    required this.accentColor,
  });

  final DashboardMatch partido;
  final int index;
  final Color cardColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final status = _statusData(partido.estado);
    final detalle = partido.marcador.isNotEmpty ? partido.marcador : status.detalleFallback;

    return Card(
      key: Key('match-card-$index'),
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Implementar navegación a SetupView o MatchView
          debugPrint('Abrir partido: ${partido.nombreLocal} vs ${partido.nombreVisitante}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                key: Key('match-card-$index-status-icon'),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(status.icon, color: status.color),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${partido.nombreLocal} vs ${partido.nombreVisitante}',
                      key: Key('match-card-$index-title'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detalle,
                      key: Key('match-card-$index-details'),
                      style: TextStyle(color: status.color, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(partido.fechaHora, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              if (partido.estado == DashboardMatchEstado.finalizado)
                IconButton(
                  icon: const Icon(Icons.file_download, color: Colors.grey),
                  onPressed: () {
                    // TODO: Implementar lógica de descarga de PDF
                    debugPrint('Descargar estadísticas de ${partido.id}');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  _DashboardMatchStatus _statusData(DashboardMatchEstado estado) {
    switch (estado) {
      case DashboardMatchEstado.enCurso:
        return _DashboardMatchStatus(
          icon: Icons.access_time,
          color: accentColor,
          detalleFallback: 'En curso',
        );
      case DashboardMatchEstado.proximo:
        return const _DashboardMatchStatus(
          icon: Icons.calendar_today,
          color: Colors.grey,
          detalleFallback: 'Próximo',
        );
      case DashboardMatchEstado.finalizado:
        return const _DashboardMatchStatus(
          icon: Icons.check_circle,
          color: Colors.green,
          detalleFallback: 'Finalizado',
        );
    }
  }
}

class _DashboardMatchStatus {
  const _DashboardMatchStatus({
    required this.icon,
    required this.color,
    required this.detalleFallback,
  });

  final IconData icon;
  final Color color;
  final String detalleFallback;
}