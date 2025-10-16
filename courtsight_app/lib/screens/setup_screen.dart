import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool _estaEditandoEquipoLocal = false;

  late final TextEditingController _nombreEquipoController;
  late final TextEditingController _jugador0NombreController;
  late final TextEditingController _jugador0DorsalController;

  @override
  void initState() {
    super.initState();
    _nombreEquipoController = TextEditingController(text: 'Equipo Local');
    _jugador0NombreController = TextEditingController(text: 'Jugador 1');
    _jugador0DorsalController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _nombreEquipoController.dispose();
    _jugador0NombreController.dispose();
    _jugador0DorsalController.dispose();
    super.dispose();
  }

  void _activarEdicionEquipoLocal() {
    setState(() {
      _estaEditandoEquipoLocal = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparación de Partido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _activarEdicionEquipoLocal,
              child: const Text('Editar Equipo Local'),
            ),
            const SizedBox(height: 16),
            if (_estaEditandoEquipoLocal)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        key: const Key('input-nombre-equipo'),
                        controller: _nombreEquipoController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Equipo Local',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Jugadores',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('input-jugador-0-nombre'),
                              controller: _jugador0NombreController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del jugador',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              key: const Key('input-jugador-0-dorsal'),
                              controller: _jugador0DorsalController,
                              decoration: const InputDecoration(
                                labelText: 'Dorsal',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
