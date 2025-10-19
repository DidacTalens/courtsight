import 'package:flutter/material.dart';

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

// --- CLASE DE MODELO PARA JUGADORES ---
class Jugador {
  String nombre;
  String dorsal;
  Jugador({this.nombre = '', this.dorsal = ''});
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
  final TextEditingController _localNameController = TextEditingController(text: 'Equipo Local');
  final TextEditingController _visitorNameController = TextEditingController(text: 'Equipo Visitante');

  // Listas de jugadores
  List<Jugador> _localRoster = [Jugador(), Jugador(), Jugador()];
  List<Jugador> _visitorRoster = [Jugador(), Jugador(), Jugador()];

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

  // Función simulada para abrir un selector de color
  void _selectColor(bool isLocal, bool isPlayer) {
    // Nota: En una app real, aquí se usaría un paquete como flutter_colorpicker
    setState(() {
      if (isLocal) {
        if (isPlayer) {
          _localPlayerColor = isPlayer ? Colors.red.shade900 : Colors.red.shade900;
        } else {
          _localKeeperColor = isPlayer ? Colors.green.shade900 : Colors.green.shade900;
        }
      } else {
        if (isPlayer) {
          _visitorPlayerColor = isPlayer ? Colors.blue.shade900 : Colors.blue.shade900;
        } else {
          _visitorKeeperColor = isPlayer ? Colors.yellow.shade900 : Colors.yellow.shade900;
        }
      }
    });
  }

  // Función para añadir un nuevo jugador
  void _addJugador(bool isLocal) {
    setState(() {
      if (isLocal) {
        _localRoster.add(Jugador());
      } else {
        _visitorRoster.add(Jugador());
      }
    });
  }

  // Verifica si el botón Iniciar Partido debe estar activo
  bool get _isReadyToStart {
    return _localNameController.text.isNotEmpty &&
        _visitorNameController.text.isNotEmpty &&
        (_localRoster.any((j) => j.nombre.isNotEmpty) || _localRoster.length > 0) &&
        (_visitorRoster.any((j) => j.nombre.isNotEmpty) || _visitorRoster.length > 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        title: const Text('Preparación del Partido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contenedor principal de dos columnas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildTeamConfigPanel(
                  isLocal: true,
                  nameController: _localNameController,
                  playerColor: _localPlayerColor,
                  keeperColor: _localKeeperColor,
                  roster: _localRoster,
                  title: 'Equipo Local',
                  cardColor: cardColor,
                )),
                const SizedBox(width: 16),
                Expanded(child: _buildTeamConfigPanel(
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
    required List<Jugador> roster,
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
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Selector de Colores (Camisetas)
          const Text('COLOR DE LAS CAMISETAS', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Camiseta Corta (Jugador)
              GestureDetector(
                onTap: () => _selectColor(isLocal, true),
                child: Column(
                  children: [
                    CamisetaCortaIcon(color: playerColor),
                    const Text('Jugador', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              // Camiseta Larga (Portero)
              GestureDetector(
                onTap: () => _selectColor(isLocal, false),
                child: Column(
                  children: [
                    CamisetaLargaIcon(color: keeperColor),
                    const Text('Portero', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Campo de Nombre del Equipo (Para consistencia visual, aunque no está en la imagen, es útil)
          TextField(
            controller: nameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nombre del Equipo',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: primaryDark.withOpacity(0.5),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),

          // Lista de Jugadores (ListView.builder dentro de un SizedBox/Container para la altura)
          ...roster.asMap().entries.map((entry) {
            int index = entry.key;
            Jugador jugador = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      onChanged: (value) => jugador.nombre = value,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Nombre del Jugador'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      onChanged: (value) => jugador.dorsal = value,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Dorsal'),
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
            label: const Text('Añadir Jugador', style: TextStyle(color: Colors.blueAccent)),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
    );
  }

  // --- BOTÓN DE INICIO DEL PARTIDO ---

  Widget _buildStartButton(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: _isReadyToStart
            ? () {
                // TODO: Navegar a MatchView (Vista de Partido)
                print('Iniciando Partido con Local: ${_localNameController.text} vs Visitante: ${_visitorNameController.text}');
              }
            : null, // Deshabilitar si no está listo
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Iniciar Partido', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}