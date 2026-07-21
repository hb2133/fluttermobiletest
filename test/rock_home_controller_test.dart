import 'package:flutter_test/flutter_test.dart';

import 'package:fluttermobiletest/panels/base/rock_home/controller/actions/rock_care_action.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_controller.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_types.dart';

class _MemoryRockCareAction implements RockCareAction {
  RockCareSnapshot Snapshot = const RockCareSnapshot(
    TotalPolish: 0,
    DailyPolish: 0,
    LastPettedDay: null,
  );

  @override
  Future<RockCareSnapshot> Load() async {
    return Snapshot;
  }

  @override
  Future<void> Save(RockCareSnapshot Value) async {
    Snapshot = Value;
  }

  @override
  Future<void> Reset() async {
    Snapshot = const RockCareSnapshot(
      TotalPolish: 0,
      DailyPolish: 0,
      LastPettedDay: null,
    );
  }
}

void main() {
  test('문지른 거리만큼 오늘의 진행도가 연속해서 증가한다', () async {
    final _MemoryRockCareAction CareAction = _MemoryRockCareAction();
    final RockHomeController Controller = RockHomeController(
      CareAction: CareAction,
      NowProvider: () => DateTime(2026, 7, 21, 23, 30),
      AutoLoad: false,
    );
    await Controller.Initialize();

    Controller.HandlePetStart();
    Controller.HandlePetProgress(25);
    Controller.HandlePetProgress(50);
    await Controller.HandlePetComplete();

    expect(Controller.State.TotalPolish, 300);
    expect(Controller.TodayPolishAmount(), 300);
    expect(Controller.State.DailyProgress, closeTo(0.03, 0.001));
    expect(CareAction.Snapshot.DailyPolish, 300);

    await Controller.ResetProgress();
    expect(Controller.State.TotalPolish, 0);
    expect(Controller.TodayPolishAmount(), 0);
    Controller.dispose();
  });

  test('일일 최대치에 도달해도 다음 날 다시 문지를 수 있다', () async {
    DateTime Now = DateTime(2026, 7, 21);
    final _MemoryRockCareAction CareAction = _MemoryRockCareAction();
    final RockHomeController Controller = RockHomeController(
      CareAction: CareAction,
      NowProvider: () => Now,
      AutoLoad: false,
    );
    await Controller.Initialize();
    Controller.HandlePetStart();
    Controller.HandlePetProgress(3000);
    await Controller.HandlePetComplete();
    expect(Controller.IsDailyLimitReached(), isTrue);

    Now = DateTime(2026, 7, 22);
    expect(Controller.TodayPolishAmount(), 0);
    expect(Controller.IsDailyLimitReached(), isFalse);
    Controller.HandlePetStart();
    Controller.HandlePetProgress(25);
    await Controller.HandlePetComplete();

    expect(
      Controller.State.TotalPolish,
      RockCarePolicy.DailyPolishTarget + 100,
    );
    expect(Controller.TodayPolishAmount(), 100);
    expect(
      Controller.State.Shine,
      closeTo(
        (RockCarePolicy.DailyPolishTarget + 100) /
            RockCarePolicy.FullShinePolish,
        0.0001,
      ),
    );
    Controller.dispose();
  });
}
