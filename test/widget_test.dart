import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:munus/main.dart';

void main() {
  testWidgets('App muestra el título Munus', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MunusApp()));
    expect(find.text('Munus'), findsOneWidget);
  });
}