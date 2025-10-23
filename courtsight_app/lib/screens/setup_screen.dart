import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courtsight/models/models.dart' as models;
import 'package:courtsight/screens/match_screen.dart';
import 'package:courtsight/models/jugador.dart' as models;
import 'package:courtsight/blocs/partido/partido_bloc.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupView();
  }
}

// --- WIDGETS DE ICONOS PERSONALIZADOS ---
// Usaremos iconos SVG o CustomPaint para la app final, pero para el código base:
// Representaremos la camiseta de jugador y portero con iconos estándar para simplicidad.

class CamisetaCortaIcon extends StatelessWidget {
  final Color color;
  const CamisetaCortaIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    // Icono simulado de camiseta de manga corta (Jugador)
    return Icon(Icons.person, color: color, size: 48);
  }
}

class CamisetaLargaIcon extends StatelessWidget {
  final Color color;
  const CamisetaLargaIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    // Icono simulado de camiseta de manga larga (Portero)
    return Icon(Icons.shield, color: color, size: 48);
  }
}

// --- WIDGET PRINCIPAL: SetupView ---

class SetupView extends StatefulWidget {
  const SetupView({super.key});

  @override
  State<SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  // Colores iniciales para las camisetas
  Color _localPlayerColor = Colors.red;
  Color _localKeeperColor = Colors.green;
  Color _visitorPlayerColor = Colors.blue;
  Color _visitorKeeperColor = Colors.yellow;

  // Controladores de texto para los nombres de los equipos
  final TextEditingController _localNameController =
      TextEditingController(text: 'Equipo Local');
  final TextEditingController _visitorNameController =
      TextEditingController(text: 'Equipo Visitante');

  // Listas de jugadores
  List<models.Jugador> _localRoster =
      List<models.Jugador>.generate(3, (_) => models.Jugador.empty());
  List<models.Jugador> _visitorRoster =
      List<models.Jugador>.generate(3, (_) => models.Jugador.empty());

  // Definición de colores oscuros para replicar el diseño
  final Color primaryDark = const Color(0xFF0A1931);
  final Color cardColor = const Color(0xFF1E2A47);
  final Color accentColor = const Color(0xFFFF8C00); // Naranja para el botón

  @override
  void dispose() {
    _localNameController.dispose();
    _visitorNameController.dispose();
    super.dispose();
  }

  static const List<Color> _uniformPalette = [
    Color(0xFFF44336),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF3F51B5),
    Color(0xFF03A9F4),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  Future<void> _selectColor(bool isLocal, bool isPlayer) async {
    final Color initialColor;
    if (isLocal) {
      initialColor = isPlayer ? _localPlayerColor : _localKeeperColor;
    } else {
      initialColor = isPlayer ? _visitorPlayerColor : _visitorKeeperColor;
    }

    Color tempColor = initialColor;

    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: cardColor,
            title: Text(
              'Selecciona color ${isPlayer ? 'jugadores' : 'portero'} ${isLocal ? 'local' : 'visitante'}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: tempColor,
                onColorChanged: (color) {
                  setStateDialog(() => tempColor = color);
                },
                availableColors: _uniformPalette,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(tempColor),
                child: const Text('Guardar'),
              ),
            ],
          );
        });
      },
    );

    if (selectedColor != null) {
      setState(() {
        if (isLocal) {
          if (isPlayer) {
            _localPlayerColor = selectedColor;
          } else {
            _localKeeperColor = selectedColor;
          }
        } else {
          if (isPlayer) {
            _visitorPlayerColor = selectedColor;
          } else {
            _visitorKeeperColor = selectedColor;
          }
        }
      });
    }
  }

  // Función para añadir un nuevo jugador
  void _addJugador(bool isLocal) {
    setState(() {
      final nuevo = models.Jugador.empty();
      if (isLocal) {
        _localRoster = [..._localRoster, nuevo];
      } else {
        _visitorRoster = [..._visitorRoster, nuevo];
      }
    });
  }

  void _updateJugador({
    required bool isLocal,
    required int index,
    String? nombre,
    String? dorsal,
  }) {
    setState(() {
      final roster = isLocal ? _localRoster : _visitorRoster;
      if (index < 0 || index >= roster.length) {
        return;
      }

      final models.Jugador original = roster[index];
      final models.Jugador actualizado = original.copyWith(
        nombre: nombre ?? original.nombre,
        dorsal: dorsal ?? original.dorsal,
      );

      final updatedRoster = List<models.Jugador>.from(roster);
      updatedRoster[index] = actualizado;

      if (isLocal) {
        _localRoster = updatedRoster;
      } else {
        _visitorRoster = updatedRoster;
      }
    });
  }

  models.Equipo _buildEquipo({
    required bool esLocal,
    required String nombre,
    required Color colorJugadores,
    required Color colorPortero,
    required List<models.Jugador> roster,
  }) {
    String toHex(Color color) =>
        '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    final jugadoresFiltrados = roster
        .where((jugador) =>
            jugador.nombre.trim().isNotEmpty &&
            jugador.dorsal.trim().isNotEmpty)
        .map((jugador) => jugador)
        .toList();

    return models.Equipo.create(
      nombre: nombre.trim(),
      colorUniforme: toHex(colorJugadores),
      colorPortero: toHex(colorPortero),
      porteroActivoId: '1',
      esLocal: esLocal,
      roster: jugadoresFiltrados,
    );
  }

  models.Partido _buildPartido() {
    final equipoLocal = _buildEquipo(
      esLocal: true,
      nombre: _localNameController.text,
      colorJugadores: _localPlayerColor,
      colorPortero: _localKeeperColor,
      roster: _localRoster,
    );

    final equipoVisitante = _buildEquipo(
      esLocal: false,
      nombre: _visitorNameController.text,
      colorJugadores: _visitorPlayerColor,
      colorPortero: _visitorKeeperColor,
      roster: _visitorRoster,
    );

    final partido = models.Partido.create(
      equipoLocal: equipoLocal,
      equipoVisitante: equipoVisitante,
    );

    return partido.copyWith(estado: models.EstadoPartido.enCurso);
  }

  // Verifica si el botón Iniciar Partido debe estar activo
  bool get _isReadyToStart {
    bool tieneJugadoresCompletos(List<models.Jugador> roster) {
      return roster.any((jugador) =>
          jugador.nombre.trim().isNotEmpty && jugador.dorsal.trim().isNotEmpty);
    }

    return _localNameController.text.trim().isNotEmpty &&
        _visitorNameController.text.trim().isNotEmpty &&
        tieneJugadoresCompletos(_localRoster) &&
        tieneJugadoresCompletos(_visitorRoster);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        title: const Text('Preparación del Partido',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contenedor principal de dos columnas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildTeamConfigPanel(
                  isLocal: true,
                  nameController: _localNameController,
                  playerColor: _localPlayerColor,
                  keeperColor: _localKeeperColor,
                  roster: _localRoster,
                  title: 'Equipo Local',
                  cardColor: cardColor,
                )),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildTeamConfigPanel(
                  isLocal: false,
                  nameController: _visitorNameController,
                  playerColor: _visitorPlayerColor,
                  keeperColor: _visitorKeeperColor,
                  roster: _visitorRoster,
                  title: 'Equipo Visitante',
                  cardColor: cardColor,
                )),
              ],
            ),
            const SizedBox(height: 30),

            // Botón de Inicio
            _buildStartButton(accentColor),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PARA CADA PANEL DE CONFIGURACIÓN DE EQUIPO ---

  Widget _buildTeamConfigPanel({
    required bool isLocal,
    required TextEditingController nameController,
    required Color playerColor,
    required Color keeperColor,
    required List<models.Jugador> roster,
    required String title,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título del Equipo
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Selector de Colores (Camisetas)
          const Text('COLOR DE LAS CAMISETAS',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Camiseta Corta (Jugador)
              GestureDetector(
                key: ValueKey(
                    'color-picker-${isLocal ? 'local' : 'visitante'}-jugadores'),
                onTap: () => _selectColor(isLocal, true),
                child: Column(
                  children: [
                    CamisetaCortaIcon(
                      key: ValueKey(
                          'icon-${isLocal ? 'local' : 'visitante'}-jugador'),
                      color: playerColor,
                    ),
                    const Text('Jugador',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              // Camiseta Larga (Portero)
              GestureDetector(
                key: ValueKey(
                    'color-picker-${isLocal ? 'local' : 'visitante'}-portero'),
                onTap: () => _selectColor(isLocal, false),
                child: Column(
                  children: [
                    CamisetaLargaIcon(
                      key: ValueKey(
                          'icon-${isLocal ? 'local' : 'visitante'}-portero'),
                      color: keeperColor,
                    ),
                    const Text('Portero',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Campo de Nombre del Equipo (Para consistencia visual, aunque no está en la imagen, es útil)
          TextField(
            key: isLocal
                ? const Key('input-equipo-local-nombre')
                : const Key('input-equipo-visitante-nombre'),
            controller: nameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nombre del Equipo',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: primaryDark.withOpacity(0.5),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),

          // Lista de Jugadores (ListView.builder dentro de un SizedBox/Container para la altura)
          ...roster.asMap().entries.map((entry) {
            final int index = entry.key;
            final models.Jugador jugador = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: KeyedSubtree(
                      key: ValueKey(
                          '${isLocal ? 'local' : 'visitante'}-${jugador.id}-nombre'),
                      child: TextFormField(
                        key: isLocal
                            ? Key('input-jugador-$index-nombre')
                            : Key('input-visitante-jugador-$index-nombre'),
                        initialValue: jugador.nombre,
                        onChanged: (value) => _updateJugador(
                          isLocal: isLocal,
                          index: index,
                          nombre: value,
                        ),
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Nombre del Jugador'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: KeyedSubtree(
                      key: ValueKey(
                          '${isLocal ? 'local' : 'visitante'}-${jugador.id}-dorsal'),
                      child: TextFormField(
                        key: isLocal
                            ? Key('input-jugador-$index-dorsal')
                            : Key('input-visitante-jugador-$index-dorsal'),
                        initialValue: jugador.dorsal,
                        onChanged: (value) => _updateJugador(
                          isLocal: isLocal,
                          index: index,
                          dorsal: value,
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Dorsal'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          // Botón Añadir Jugador
          TextButton.icon(
            onPressed: () => _addJugador(isLocal),
            icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
            label: const Text('Añadir Jugador',
                style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  // --- FUNCIÓN DECORACIÓN DE ENTRADA DE TEXTO ---

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: primaryDark.withOpacity(0.5),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
    );
  }

  // --- BOTÓN DE INICIO DEL PARTIDO ---

  Widget _buildStartButton(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: _isReadyToStart
            ? () {
                final partido = _buildPartido();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => PartidoBloc(
                        loadPartido: (_) async => partido,
                        initialPartido: partido,
                      ),
                      child: MatchView(partido: partido),
                    ),
                  ),
                );
              }
            : null, // Deshabilitar si no está listo
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Iniciar Partido',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
