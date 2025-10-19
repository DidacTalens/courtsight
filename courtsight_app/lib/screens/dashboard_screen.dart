import 'package:courtsight/widgets/dashboard/config_team_card_dashboard_widget.dart';
import 'package:courtsight/widgets/dashboard/match_list_dashboard_widget.dart';
import 'package:courtsight/widgets/dashboard/match_title_dashboard_widget.dart';
import 'package:courtsight/widgets/dashboard/segmented_control_dashboard_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.onNavigateToSetup,
  });

  static const String setupRoute = '/setup';

  final void Function(String route)? onNavigateToSetup;

  @override
  Widget build(BuildContext context) {
    return DashboardView(
      onNavigateToSetup: onNavigateToSetup,
    );
  }
}

// --- Datos de demostración para la Dashboard ---

final List<DashboardMatch> _partidos = List<DashboardMatch>.from(demoDashboardMatches);

// --- WIDGET PRINCIPAL: DashboardView ---

class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
    this.onNavigateToSetup,
  });

  final void Function(String route)? onNavigateToSetup;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // 0: En Curso/Próximos, 1: Finalizados
  int _filtroSeleccionado = 0;

  void _irAPreparacion() {
    final callback = widget.onNavigateToSetup;
    if (callback != null) {
      callback(DashboardScreen.setupRoute);
    } else {
      Navigator.of(context).pushNamed(DashboardScreen.setupRoute);
    }
  }

  List<DashboardMatch> get _partidosFiltrados {
    if (_filtroSeleccionado == 0) {
      return _partidos.where((p) => p.estado != DashboardMatchEstado.finalizado).toList();
    }
    return _partidos.where((p) => p.estado == DashboardMatchEstado.finalizado).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Definición de colores oscuros para replicar el diseño
    const Color primaryDark = Color(0xFF0A1931); // Fondo principal
    const Color cardColor = Color(0xFF1E2A47); // Fondo de tarjetas/elementos
    const Color accentColor = Color(0xFF1E90FF); // Azul claro para acentos

    final partidosFiltrados = _partidosFiltrados;

    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_handball, color: accentColor),
            SizedBox(width: 8),
            Text('Estadísticas de Balonmano', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      
      // BOTÓN DE ACCIÓN FLOTANTE (FAB)
      floatingActionButton: FloatingActionButton(
        key: const Key('dashboard-fab'),
        onPressed: _irAPreparacion,
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. TARJETA DE CONFIGURACIÓN DEL EQUIPO
            _buildConfigTeamCard(cardColor, accentColor, context),
            const SizedBox(height: 20),

            // 2. CONTROL DE SEGMENTACIÓN (ToggleButtons para simular)
            _buildSegmentedControl(cardColor, accentColor),
            const SizedBox(height: 20),

            // 3. LISTADO DE PARTIDOS
            _buildMatchList(partidosFiltrados, cardColor, accentColor, context),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigTeamCard(Color cardColor, Color accentColor, BuildContext context) {
    return DashboardConfigTeamCard(
      cardColor: cardColor,
      accentColor: accentColor,
      onTap: _irAPreparacion,
    );
  }

  Widget _buildSegmentedControl(Color cardColor, Color accentColor) {
    return DashboardSegmentedControl(
      selectedIndex: _filtroSeleccionado,
      onSelected: (index) {
        setState(() {
          _filtroSeleccionado = index;
        });
      },
      cardColor: cardColor,
      accentColor: accentColor,
    );
  }

  Widget _buildMatchList(
    List<DashboardMatch> partidos,
    Color cardColor,
    Color accentColor,
    BuildContext context,
  ) {
    return DashboardMatchList(
      partidos: partidos,
      cardColor: cardColor,
      accentColor: accentColor,
    );
  }
}