import 'package:flutter_test/flutter_test.dart';
import 'package:aeccde_app/app.dart';

void main() {
  testWidgets('AECCDE App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AeccdeApp());
    expect(find.byType(AeccdeApp), findsOneWidget);
  });
}
