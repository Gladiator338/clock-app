import 'package:flutter_test/flutter_test.dart';
import 'package:clock_app/app.dart';

void main() {
  testWidgets('App loads and shows bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const ClockApp());
    await tester.pumpAndSettle();
    expect(find.text('Clock'), findsOneWidget);
    expect(find.text('Timer'), findsOneWidget);
    expect(find.text('Alarm'), findsOneWidget);
    expect(find.text('Stopwatch'), findsOneWidget);
  });
}
