import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const String setupRoute = '/setup';

  void _irAPreparacion(BuildContext context) {
    Navigator.of(context).pushNamed(setupRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CourtSight'),
      ),
      body: const Center(
        child: Text('Contenido del dashboard pendiente'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _irAPreparacion(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
