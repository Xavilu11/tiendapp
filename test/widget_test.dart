// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';

import 'package:emprende/main.dart';

void main() {
  testWidgets('muestra el splash y navega al inicio', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pides aquí, impulsas allá'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenido a Emprende'), findsOneWidget);
  });

  testWidgets('permite abrir el formulario de login', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login (usuarios registrados)'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
}
