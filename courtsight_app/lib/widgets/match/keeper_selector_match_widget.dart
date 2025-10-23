import 'package:flutter/material.dart';
import 'package:courtsight/models/equipo.dart';
import 'package:courtsight/models/jugador.dart';

// Colores del tema
const Color cardColor = Color(0xFF1E2A47);
const Color accentColor = Color(0xFF1E90FF);

class KeeperSelectorModal extends StatelessWidget {
  const KeeperSelectorModal({
    super.key,
    required this.equipo,
    required this.onKeeperSelected,
  });

  final Equipo equipo;
  final Function(String jugadorId) onKeeperSelected;

  // Filtra los jugadores que tienen dorsal y nombre
  List<Jugador> get _availableRoster => equipo.roster
      .where((j) => j.dorsal.isNotEmpty && j.nombre.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: cardColor,
      title: Text(
        'Cambiar Portero Activo - ${equipo.nombre}',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _availableRoster.length,
          itemBuilder: (context, index) {
            final jugador = _availableRoster[index];
            final bool isCurrentKeeper = equipo.porteroActivoId == jugador.id;

            return _buildPlayerTile(context, jugador, isCurrentKeeper);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child:
              const Text('Cancelar', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(
      BuildContext context, Jugador jugador, bool isCurrentKeeper) {
    return ListTile(
      onTap: () {
        onKeeperSelected(jugador.id);
        Navigator.of(context).pop();
      },
      leading: CircleAvatar(
        backgroundColor: equipo.colorPorteroColor,
        child: Text(jugador.dorsal,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Text(jugador.nombre, style: const TextStyle(color: Colors.white)),
      trailing: isCurrentKeeper
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
    );
  }
}
