import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermobiletest/app/shell/app_shell.dart';

void main() {
  testWidgets('AppShell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppShell());

    expect(find.text('Panel-Section bootstrap shell.'), findsOneWidget);
  });
}
