import 'package:flutter/material.dart';
import 'package:courtsight/models/models.dart' as models;

class SevenMeterResult {
  SevenMeterResult({
    required this.equipoPorteroId,
    required this.porteroId,
    required this.equipoLanzadorId,
    required this.lanzadorId,
    required this.esGol,
    required this.amonestacion,
  });

  final String equipoPorteroId;
  final String porteroId;
  final String equipoLanzadorId;
  final String lanzadorId;
  final bool esGol;
  final bool amonestacion;
}

class SevenMeterDialogMatchWidget extends StatefulWidget {
  const SevenMeterDialogMatchWidget({
    super.key,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.localAtacando,
  });

  final models.Equipo equipoLocal;
  final models.Equipo equipoVisitante;
  final bool localAtacando;

  @override
  State<SevenMeterDialogMatchWidget> createState() =>
      _SevenMeterDialogMatchWidgetState();
}

class _SevenMeterDialogMatchWidgetState
    extends State<SevenMeterDialogMatchWidget> {
  late models.Equipo _equipoAtacante;
  late models.Equipo _equipoDefensor;

  String? _lanzadorId;
  String? _porteroId;
  bool _esGol = true;
  bool _amonestacion = false;

  bool get _isReady => _lanzadorId != null && _porteroId != null;

  @override
  void initState() {
    super.initState();
    _equipoAtacante =
        widget.localAtacando ? widget.equipoLocal : widget.equipoVisitante;
    _equipoDefensor =
        widget.localAtacando ? widget.equipoVisitante : widget.equipoLocal;
    _lanzadorId = _primerJugadorDisponible(_equipoAtacante)?.id;
    _porteroId = _primerJugadorDisponible(_equipoDefensor)?.id;
  }

  models.Jugador? _primerJugadorDisponible(models.Equipo equipo) {
    return equipo.roster.firstWhere(
      (jugador) => jugador.nombre.isNotEmpty,
      orElse: () => equipo.roster.isNotEmpty
          ? equipo.roster.first
          : models.Jugador.create(nombre: 'Jugador', dorsal: '0'),
    );
  }

  models.Jugador? _buscarJugador(models.Equipo equipo, String? jugadorId) {
    if (jugadorId == null) return null;
    return equipo.roster.firstWhere(
      (jugador) => jugador.id == jugadorId,
      orElse: () => models.Jugador.create(nombre: 'Jugador', dorsal: '0'),
    );
  }

  List<models.Jugador> _jugadoresDisponibles(models.Equipo equipo) {
    return equipo.roster.where((jugador) => jugador.nombre.isNotEmpty).toList();
  }

  Future<void> _seleccionarJugador({
    required models.Equipo equipo,
    required bool esLanzador,
  }) async {
    final jugadores = _jugadoresDisponibles(equipo);
    if (jugadores.isEmpty) {
      return;
    }

    final seleccionado = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF1E2A47),
      builder: (context) {
        return ListView.separated(
          itemCount: jugadores.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            final jugador = jugadores[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white10,
                child: Text(jugador.dorsal.isEmpty ? '?' : jugador.dorsal),
              ),
              title: Text(
                jugador.nombre,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(context).pop(jugador.id),
            );
          },
        );
      },
    );

    if (seleccionado != null) {
      setState(() {
        if (esLanzador) {
          _lanzadorId = seleccionado;
        } else {
          _porteroId = seleccionado;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final atacante = _buscarJugador(_equipoAtacante, _lanzadorId);
    final portero = _buscarJugador(_equipoDefensor, _porteroId);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A47),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lanzamiento de 7 metros',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ataca: ${_equipoAtacante.nombre.isEmpty ? 'Equipo atacante' : _equipoAtacante.nombre}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        'Defiende: ${_equipoDefensor.nombre.isEmpty ? 'Equipo defensor' : _equipoDefensor.nombre}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildVisualSection(atacante: atacante, portero: portero),
            const SizedBox(height: 20),
            _buildTwoMinutesButton(),
            const SizedBox(height: 20),
            _buildResultButtons(),
            const SizedBox(height: 20),
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualSection({
    required models.Jugador? atacante,
    required models.Jugador? portero,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildPlayerColumn(
                jugador: portero,
                equipo: _equipoDefensor,
                etiqueta: 'Portero',
                onTap: () => _seleccionarJugador(
                  equipo: _equipoDefensor,
                  esLanzador: false,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildPlayerColumn(
                jugador: atacante,
                equipo: _equipoAtacante,
                etiqueta: 'Lanzador',
                onTap: () => _seleccionarJugador(
                  equipo: _equipoAtacante,
                  esLanzador: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerColumn({
    required models.Jugador? jugador,
    required models.Equipo equipo,
    required String etiqueta,
    required VoidCallback onTap,
  }) {
    final nombre =
        jugador?.nombre.isNotEmpty == true ? jugador!.nombre : 'Seleccionar';
    final dorsal = jugador?.dorsal ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          etiqueta == 'Portero' ? Icons.shield : Icons.sports_handball,
          color: equipo.colorPorteroColor,
          size: 40,
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Text(
                nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (dorsal.isNotEmpty)
                Text(
                  '#$dorsal',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              const SizedBox(height: 4),
              Text(
                'Cambiar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTwoMinutesButton() {
    final activeColor =
        _amonestacion ? const Color(0xFFCC8400) : Colors.white24;
    return ElevatedButton.icon(
      onPressed: () {
        setState(() => _amonestacion = !_amonestacion);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: activeColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.access_time_filled, color: Colors.white),
      label: Text(
        '2 minutos${_amonestacion ? ' asignados' : ''}',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildResultButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() => _esGol = true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _esGol
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF4CAF50).withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.sports_soccer, color: Colors.white),
            label: const Text(
              'Gol',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() => _esGol = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: !_esGol
                  ? const Color(0xFFF44336)
                  : const Color(0xFFF44336).withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.back_hand, color: Colors.white),
            label: const Text(
              'Parada',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isReady
                ? () {
                    Navigator.of(context).pop(
                      SevenMeterResult(
                        equipoPorteroId: _equipoDefensor.id,
                        porteroId: _porteroId!,
                        equipoLanzadorId: _equipoAtacante.id,
                        lanzadorId: _lanzadorId!,
                        esGol: _esGol,
                        amonestacion: _amonestacion,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text('Registrar'),
          ),
        ),
      ],
    );
  }
}

// --- CONSTANTES DE ESTILO ---
const Color primaryDark = Color(0xFF0A1931);
const Color cardColor = Color(0xFF1E2A47);
const Color successColor = Color(0xFF4CAF50); // Verde para 'Gol'
const Color failureColor = Color(0xFFF44336); // Rojo para 'Parada'
const Color warningColor = Color(0xFFCC8400); // Naranja oscuro para '2 Minutos'
const Color textPrimary = Colors.white;
const Color textSecondary = Colors.grey;

// --- WIDGET PRINCIPAL: SevenMeterDialogVisual ---

class SevenMeterDialogVisual extends StatelessWidget {
  const SevenMeterDialogVisual({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el Dialog para replicar el modal de la imagen
    return Dialog(
      backgroundColor: Colors
          .transparent, // Fondo transparente para que el cardColor sea el dominante
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Encabezado (Título y Botón Cerrar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lanzamiento de 7 Metros',
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: textSecondary),
                  onPressed: () =>
                      Navigator.of(context).pop(), // Simulación de cierre
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Gráfico/Visualización del Lanzamiento
            _buildActionVisualization(),
            const SizedBox(height: 20),

            // 3. Botón de Acción Adicional (2 Minutos)
            _buildActionTimerButton(),
            const SizedBox(height: 20),

            // 4. Botones de Resultado Principal
            _buildResultButtons(),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS INTERNOS ---

  Widget _buildActionVisualization() {
    return Center(
      child: SizedBox(
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Simulación de la Portería (Puerta)
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: textSecondary, width: 2),
              ),
            ),

            // Línea de 7 metros (Arco discontinuo)
            CustomPaint(
              size: const Size(100, 100),
              painter: DashedArcPainter(),
            ),

            // Portero
            Positioned(
              left: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield,
                      color: Colors.blueAccent,
                      size: 40), // Icono simulado de portero
                  const Text('Portero',
                      style: TextStyle(color: textSecondary, fontSize: 12)),
                ],
              ),
            ),

            // Lanzador
            Positioned(
              right: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.man_2,
                      color: Colors.white70,
                      size: 40), // Icono simulado de lanzador
                  const Text('Lanzador',
                      style: TextStyle(color: textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTimerButton() {
    return ElevatedButton.icon(
      onPressed: () {}, // Simulación de acción
      style: ElevatedButton.styleFrom(
        backgroundColor: warningColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.access_time_filled, color: textPrimary),
      label: const Text('2 Minutos',
          style: TextStyle(color: textPrimary, fontSize: 16)),
    );
  }

  Widget _buildResultButtons() {
    return Row(
      children: [
        // Botón GOL
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {}, // Simulación de acción
            style: ElevatedButton.styleFrom(
              backgroundColor: successColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.sports_soccer, color: textPrimary, size: 24),
            label: const Text('Gol',
                style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),

        // Botón PARADA
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {}, // Simulación de acción
            style: ElevatedButton.styleFrom(
              backgroundColor: failureColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.back_hand, color: textPrimary, size: 24),
            label: const Text('Parada',
                style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// --- PINTOR PERSONALIZADO PARA EL ARCO DISCONTINUO ---

class DashedArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double startAngle = -3 * 3.14159 / 4; // Aproximadamente -135 grados
    double sweepAngle = 3 * 3.14159 / 2; // Aproximadamente 270 grados

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 * 0.7, // Radio del arco
    );

    double currentAngle = startAngle;
    while (currentAngle < startAngle + sweepAngle) {
      double sweep = dashWidth / rect.width;

      // Dibujar guión
      canvas.drawArc(rect, currentAngle, sweep, false, paint);

      // Mover al espacio
      currentAngle += sweep + (dashSpace / rect.width);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
