import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttermobiletest/app/shell/app_shell.dart';

void main() {
  testWidgets('넓은 화면에서도 주요 UI가 화면 중앙 축에 배치된다', (WidgetTester Tester) async {
    Tester.view.physicalSize = const Size(1200, 800);
    Tester.view.devicePixelRatio = 1;
    addTearDown(Tester.view.resetPhysicalSize);
    addTearDown(Tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await Tester.pumpWidget(const AppShell());
    await Tester.pumpAndSettle();

    const double ScreenCenterX = 600;
    expect(
      Tester.getCenter(find.text('화면 속 돌멩이')).dx,
      closeTo(ScreenCenterX, 1),
    );
    expect(
      Tester.getCenter(find.byKey(const Key('rock.garden.character'))).dx,
      closeTo(ScreenCenterX, 1),
    );
    expect(
      Tester.getCenter(find.byKey(const Key('rock.daily_pet.progress'))).dx,
      closeTo(ScreenCenterX, 1),
    );
  });

  testWidgets('화면 속 돌멩이를 표시하고 쓰다듬은 오늘을 기록한다', (WidgetTester Tester) async {
    Tester.view.physicalSize = const Size(390, 844);
    Tester.view.devicePixelRatio = 1;
    addTearDown(Tester.view.resetPhysicalSize);
    addTearDown(Tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await Tester.pumpWidget(const AppShell());
    await Tester.pumpAndSettle();

    expect(find.text('화면 속 돌멩이'), findsOneWidget);
    expect(find.text('아무 일도 일어나지 않습니다.'), findsOneWidget);
    expect(find.text('아직 쓰다듬지 않은 돌멩이'), findsOneWidget);
    expect(
      Tester.getCenter(find.byKey(const Key('rock.garden.character'))).dy,
      inInclusiveRange(250, 520),
    );

    final Finder Rock = find.byKey(const Key('rock.garden.character'));
    final TestGesture Gesture = await Tester.startGesture(
      Tester.getCenter(Rock),
    );
    await Gesture.moveBy(const Offset(36, 0));
    await Tester.pump();
    expect(find.byKey(const Key('rock.touch.highlight')), findsOneWidget);
    await Gesture.up();
    await Tester.pumpAndSettle();
    expect(find.byKey(const Key('rock.touch.highlight')), findsNothing);

    expect(find.text('돌멩이가 조금 더 반짝입니다'), findsOneWidget);
    expect(find.text('돌멩이 위를 누른 채 부드럽게 문질러 보세요'), findsOneWidget);
    final LinearProgressIndicator Progress =
        Tester.widget<LinearProgressIndicator>(
          find.byKey(const Key('rock.daily_pet.progress')),
        );
    expect(Progress.value, greaterThan(0));
    expect(Progress.value, lessThan(1));

    await Tester.tap(find.byKey(const Key('rock.cheat.reset')));
    await Tester.pumpAndSettle();
    final LinearProgressIndicator ResetProgress =
        Tester.widget<LinearProgressIndicator>(
          find.byKey(const Key('rock.daily_pet.progress')),
        );
    expect(ResetProgress.value, 0);
    expect(find.text('아직 쓰다듬지 않은 돌멩이'), findsOneWidget);
  });
}
