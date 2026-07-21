import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttermobiletest/panels/base/rock_home/controller/actions/rock_care_action.dart';

void main() {
  test('기존 횟수 저장 기록을 새 연속 진행도 형식으로 읽는다', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'screen_rock.total_pets': 3,
      'screen_rock.daily_pets': 2,
      'screen_rock.last_petted_day': '2026-07-21',
    });
    final RockCareAction Action = RockCareAction();

    final RockCareSnapshot Legacy = await Action.Load();
    const RockCareSnapshot Saved = RockCareSnapshot(
      TotalPolish: 450,
      DailyPolish: 350,
      LastPettedDay: '2026-07-21',
    );
    await Action.Save(Saved);
    final RockCareSnapshot Reloaded = await Action.Load();

    expect(Legacy.TotalPolish, 300);
    expect(Legacy.DailyPolish, 200);
    expect(Reloaded.TotalPolish, 450);
    expect(Reloaded.DailyPolish, 350);

    await Action.Reset();
    final RockCareSnapshot Reset = await Action.Load();
    expect(Reset.TotalPolish, 0);
    expect(Reset.DailyPolish, 0);
  });
}
