import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/main.dart';

void main() {
  testWidgets('MyApp muestra la tarjeta de configuración del equipo',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Configurar mi equipo'), findsOneWidget);
  });
}
