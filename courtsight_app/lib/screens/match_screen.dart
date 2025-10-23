import 'dart:math' as math;

import 'package:courtsight/widgets/match/keeper_selector_match_widget.dart';
import 'package:courtsight/widgets/match/seven_meter_dialog_match_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courtsight/models/models.dart' as models;
import 'package:courtsight/blocs/partido/partido_bloc.dart';
import 'package:courtsight/blocs/partido/partido_event.dart';
import 'package:courtsight/blocs/partido/partido_state.dart';
import 'package:intl/intl.dart';

// Definición de colores oscuros para replicar el diseño
const Color primaryDark = Color(0xFF0A1931);
const Color cardColor = Color(0xFF1E2A47);
const Color accentColor = Color(0xFF1E90FF); // Azul para acentos
const Color errorColor = Color(0xFFDC3545); // Rojo para Pérdida/Advertencia
const Color successColor = Color(0xFF28A745); // Verde para Gol/Éxito

// --- WIDGET PRINCIPAL: MatchView ---

class MatchView extends StatefulWidget {
  const MatchView({super.key, required this.partido});

  final models.Partido partido;

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  late models.Partido _partido;
  late models.Equipo _equipoLocal;
  late models.Equipo _equipoVisitante;

  late int _marcadorLocal;
  late int _marcadorVisitante;
  late String _tiempoTranscurrido;
  late bool _localIsAttacking;

  late List<String> _parcialesLocal;
  late List<String> _parcialesVisitante;
  late List<String> _parcialLabels;

  @override
  void initState() {
    super.initState();
    _syncFromPartido(widget.partido);
  }

  void _syncFromPartido(models.Partido partido) {
    _partido = partido;
    _equipoLocal = partido.equipoLocal;
    _equipoVisitante = partido.equipoVisitante;

    _marcadorLocal = partido.marcadorLocal;
    _marcadorVisitante = partido.marcadorVisitante;
    _tiempoTranscurrido = partido.tiempoFormateado;
    _localIsAttacking = partido.equipoEnAtaque != null &&
        partido.equipoEnAtaque == partido.equipoLocal.id;

    _parcialesLocal =
        partido.parciales.map((p) => p.golesLocal.toString()).toList();
    _parcialesVisitante =
        partido.parciales.map((p) => p.golesVisitante.toString()).toList();
    _parcialLabels = partido.parciales.map((p) => p.rangoTiempo).toList();
  }

  void _togglePossession() {
    setState(() {
      _localIsAttacking = !_localIsAttacking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PartidoBloc, PartidoState>(
        listener: (context, state) {
          final partido = state.partido;
          if (partido != null && partido != _partido) {
            setState(() {
              _syncFromPartido(partido);
            });
          }
        },
        child: Scaffold(
          backgroundColor: primaryDark,
          body: SafeArea(
            child: Row(
              children: [
                // --- COLUMNA 1: Marcador, Pista y Botones de Acción (Aprox. 70%) ---
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      // 1. Encabezado del Marcador
                      _buildScoreHeader(),

                      // 2. Tabla de Parciales
                      _buildParcialsTable(),
                      const SizedBox(height: 20),

                      // 3. Pista de Balonmano
                      Expanded(
                        child: _buildHandballPitch(),
                      ),

                      // 4. Botones de Acción (Barra inferior)
                      _buildActionButtonsBar(),
                    ],
                  ),
                ),

                // --- COLUMNA 2: Historial de Acciones (Aprox. 30%) ---
                Expanded(
                  flex: 3,
                  child: _buildHistoryPanel(),
                ),
              ],
            ),
          ),
        ));
  }

  // --- WIDGETS MODULARES ---

  Widget _buildScoreHeader() {
    final String nombreLocal =
        _equipoLocal.nombre.isEmpty ? 'Equipo Local' : _equipoLocal.nombre;
    final String nombreVisitante = _equipoVisitante.nombre.isEmpty
        ? 'Equipo Visitante'
        : _equipoVisitante.nombre;

    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 16.0, right: 16.0, bottom: 5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _equipoLocal.color,
                      border: Border.all(
                        color: _localIsAttacking ? accentColor : Colors.white38,
                        width: _localIsAttacking ? 2 : 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(nombreLocal,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Expanded(
                child: Text('$_marcadorLocal-$_marcadorVisitante',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'RobotoMono')),
              ),
              Row(
                children: [
                  Text(nombreVisitante,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _equipoVisitante.color,
                      border: Border.all(
                        color:
                            !_localIsAttacking ? accentColor : Colors.white38,
                        width: !_localIsAttacking ? 2 : 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(_tiempoTranscurrido,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  fontFamily: 'RobotoMono')),
        ],
      ),
    );
  }

  Widget _buildParcialsTable() {
    if (_parcialLabels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 80),
              ..._parcialLabels.map(
                (label) => Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 10),
          _buildParcialRow(
            _equipoLocal.nombre.isEmpty ? 'Equipo Local' : _equipoLocal.nombre,
            _parcialesLocal,
            accentColor,
          ),
          _buildParcialRow(
            _equipoVisitante.nombre.isEmpty
                ? 'Equipo Visitante'
                : _equipoVisitante.nombre,
            _parcialesVisitante,
            Colors.yellow,
          ),
        ],
      ),
    );
  }

  Widget _buildParcialRow(
      String teamName, List<String> scores, Color teamColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              teamName,
              style: TextStyle(color: teamColor, fontWeight: FontWeight.bold),
            ),
          ),
          ...scores.map(
            (score) => Expanded(
              child: Text(
                score,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandballPitch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: primaryDark,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double maxHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : MediaQuery.of(context).size.height * 0.35;
          final double preferredHeight = width / 2.2;
          final double height = math.min(preferredHeight, maxHeight);

          return SizedBox(
            width: width,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: HandballPitchPainter(),
                    child: Container(),
                  ),
                  Positioned(
                    left: width * 0.05,
                    child: _buildKeeperIcon(
                      equipo: _equipoLocal,
                      isLocal: true,
                    ),
                  ),
                  Positioned(
                    right: width * 0.05,
                    child: _buildKeeperIcon(
                      equipo: _equipoVisitante,
                      isLocal: false,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _localIsAttacking ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.arrow_forward,
                        color: accentColor, size: 50),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeeperIcon(
      {required models.Equipo equipo, required bool isLocal}) {
    final models.Jugador? porteroActivo =
        equipo.roster.cast<models.Jugador?>().firstWhere(
              (jugador) => jugador?.id == equipo.porteroActivoId,
              orElse: () => null,
            );

    final String nombrePortero =
        porteroActivo != null && porteroActivo.nombre.isNotEmpty
            ? porteroActivo.nombre
            : 'Portero';
    final String dorsalPortero =
        porteroActivo != null && porteroActivo.dorsal.isNotEmpty
            ? '#${porteroActivo.dorsal}'
            : '';

    return GestureDetector(
      onTap: () async {
        final partidoBloc = context.read<PartidoBloc>();
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return KeeperSelectorModal(
              equipo: equipo,
              onKeeperSelected: (jugadorId) {
                partidoBloc.add(
                  PartidoCambioPortero(
                    equipoId: equipo.id,
                    nuevoPorteroId: jugadorId,
                  ),
                );
              },
            );
          },
        );
      },
      child: Column(
        children: [
          Icon(Icons.shield, color: equipo.colorPorteroColor, size: 42),
          const SizedBox(height: 4),
          Text(nombrePortero,
              style: TextStyle(color: equipo.colorPorteroColor, fontSize: 12)),
          if (dorsalPortero.isNotEmpty)
            Text(dorsalPortero,
                style:
                    TextStyle(color: equipo.colorPorteroColor, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionButtonsBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.score, '7m', successColor, () async {
            final resultado = await showDialog<SevenMeterResult>(
              context: context,
              builder: (dialogContext) => SevenMeterDialogMatchWidget(
                equipoLocal: _equipoLocal,
                equipoVisitante: _equipoVisitante,
                localAtacando: _localIsAttacking,
              ),
            );

            if (resultado != null) {
              context.read<PartidoBloc>().add(
                    PartidoSieteMetrosRegistrado(
                      equipoPorteroId: resultado.equipoPorteroId,
                      porteroId: resultado.porteroId,
                      equipoLanzadorId: resultado.equipoLanzadorId,
                      lanzadorId: resultado.lanzadorId,
                      esGol: resultado.esGol,
                      amonestacion: resultado.amonestacion,
                    ),
                  );
            }
          }),
          _buildActionButton(
            Icons.warning_amber_rounded,
            'Amonestación',
            Colors.orange,
            () {
              print('Modal Amonestación');
            },
          ),
          _buildActionButton(
            Icons.sports_handball,
            'Lanzamiento',
            Colors.teal,
            () {
              print('Modal Lanzamiento');
            },
          ),
          _buildActionButton(
            Icons.swap_horiz,
            'Posesión',
            Colors.purple,
            _togglePossession,
          ),
          _buildActionButton(
            Icons.timer_off,
            'Tiempo Muerto',
            errorColor,
            () {
              print('Tiempo Muerto');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.5), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildHistoryPanel() {
    final acciones = _partido.acciones;

    return Container(
      color: primaryDark.withOpacity(0.8),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial de acciones',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: acciones.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin acciones registradas.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: acciones.length,
                      itemBuilder: (context, index) {
                        final accion = acciones[index];
                        return _buildHistoryTile(accion);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTile(models.Accion accion) {
    final color = _historyColor(accion);
    final timeText = DateFormat('HH:mm:ss').format(accion.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 35,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
            margin: const EdgeInsets.only(right: 8),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accion.descripcion,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  timeText,
                  style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _historyColor(models.Accion accion) {
    switch (accion.tipo) {
      case models.AccionTipo.sieteMetros:
        return accion.resultado == 'Gol' ? successColor : errorColor;
    }
  }
}

// --- CLASE CUSTOMPAINTER PARA DIBUJAR LA PISTA ---
// Simplificación de las líneas de la pista de balonmano
class HandballPitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double w = size.width;
    final double h = size.height;

    // Líneas del campo (exterior)
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), linePaint);

    // Línea central
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), linePaint);

    // Zonas de 6m (aproximado, como semicírculos)
    final double r = w * 0.1; // Radio aproximado para la zona

    // Zona de 6m izquierda
    canvas.drawArc(
      Rect.fromCenter(center: Offset(0, h / 2), width: r * 2, height: h),
      -0.5 * 3.14159, // Start angle (Top)
      1.0 * 3.14159, // Sweep angle (180 degrees)
      false,
      linePaint,
    );

    // Zona de 6m derecha
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w, h / 2), width: r * 2, height: h),
      0.5 * 3.14159, // Start angle (Bottom)
      1.0 * 3.14159, // Sweep angle (180 degrees)
      false,
      linePaint,
    );

    // Líneas de 7m (simulación)
    canvas.drawCircle(Offset(w * 0.15, h / 2), 5, linePaint);
    canvas.drawCircle(Offset(w * 0.85, h / 2), 5, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
