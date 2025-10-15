import 'package:flutter/material.dart';
import 'package:courtsight/models/models.dart';

class ParcialesWidget extends StatelessWidget {
  final Partido partido;

  const ParcialesWidget({
    Key? key,
    required this.partido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Parciales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de parciales
          partido.parciales.isEmpty
              ? const Text(
                  'Sin parciales',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: partido.parciales.length,
                    itemBuilder: (context, index) {
                      final parcial = partido.parciales[index];
                      final esParcialActual = parcial == partido.parcialActual;

                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: esParcialActual ? Colors.blue.shade100 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: esParcialActual ? Colors.blue : Colors.grey.shade300,
                            width: esParcialActual ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tiempo del parcial
                            Text(
                              parcial.rangoTiempo,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: esParcialActual ? FontWeight.bold : FontWeight.normal,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Marcador del parcial
                            Text(
                              parcial.marcador,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: esParcialActual ? FontWeight.bold : FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}