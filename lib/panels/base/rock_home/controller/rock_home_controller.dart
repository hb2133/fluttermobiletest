import 'package:flutter/foundation.dart';

import 'package:fluttermobiletest/panels/base/rock_home/controller/actions/rock_care_action.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_state.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_types.dart';

typedef RockNowProvider = DateTime Function();

class RockHomeController extends ChangeNotifier {
  RockHomeController({
    RockCareAction? CareAction,
    RockNowProvider? NowProvider,
    bool AutoLoad = true,
  }) : _CareAction = CareAction ?? RockCareAction(),
       _NowProvider = NowProvider ?? DateTime.now {
    if (AutoLoad == true) {
      Initialize();
    }
  }

  final RockCareAction _CareAction;
  final RockNowProvider _NowProvider;
  RockHomeState _State = RockHomeState.Initial();
  bool _IsDisposed = false;

  RockHomeState get State => _State;

  Future<void> Initialize() async {
    final RockCareSnapshot Snapshot = await _CareAction.Load();
    if (_IsDisposed == true) {
      return;
    }

    final String TodayKey = _DayKey(_NowProvider());
    _State = _State.CopyWith(
      TotalPolish: Snapshot.TotalPolish,
      TodayPolish: Snapshot.LastPettedDay == TodayKey
          ? Snapshot.DailyPolish
          : 0,
      LastPettedDay: Snapshot.LastPettedDay,
      IsLoading: false,
    );
    notifyListeners();
  }

  void HandlePetStart() {
    if (_State.IsLoading == true ||
        _State.IsPetting == true ||
        IsDailyLimitReached() == true) {
      return;
    }
    _State = _State.CopyWith(IsPetting: true);
    notifyListeners();
  }

  void HandlePetProgress(double Distance) {
    if (_State.IsLoading == true ||
        _State.IsPetting == false ||
        IsDailyLimitReached() == true ||
        Distance <= 0) {
      return;
    }

    final String TodayKey = _DayKey(_NowProvider());
    final int CurrentTodayPolish = TodayPolishAmount();
    final int RequestedPolish =
        (Distance * RockCarePolicy.PolishPerLogicalPixel).round();
    final int AddedPolish = RequestedPolish.clamp(
      0,
      RockCarePolicy.DailyPolishTarget - CurrentTodayPolish,
    );
    if (AddedPolish == 0) {
      return;
    }

    _State = _State.CopyWith(
      TotalPolish: _State.TotalPolish + AddedPolish,
      TodayPolish: CurrentTodayPolish + AddedPolish,
      LastPettedDay: TodayKey,
    );
    notifyListeners();
  }

  Future<void> HandlePetComplete() async {
    if (_State.IsLoading == true || _State.IsPetting == false) {
      return;
    }

    _State = _State.CopyWith(
      IsPetting: false,
      ReactionToken: _State.ReactionToken + 1,
    );
    notifyListeners();

    await _CareAction.Save(
      RockCareSnapshot(
        TotalPolish: _State.TotalPolish,
        DailyPolish: TodayPolishAmount(),
        LastPettedDay: _State.LastPettedDay,
      ),
    );
  }

  void HandlePetCancel() {
    if (_State.IsPetting == false) {
      return;
    }
    _State = _State.CopyWith(IsPetting: false);
    notifyListeners();
  }

  Future<void> ResetProgress() async {
    await _CareAction.Reset();
    if (_IsDisposed == true) {
      return;
    }

    _State = RockHomeState.Initial().CopyWith(
      IsLoading: false,
      ReactionToken: _State.ReactionToken,
    );
    notifyListeners();
  }

  bool IsDailyLimitReached() {
    return TodayPolishAmount() >= RockCarePolicy.DailyPolishTarget;
  }

  int TodayPolishAmount() {
    return _State.LastPettedDay == _DayKey(_NowProvider())
        ? _State.TodayPolish
        : 0;
  }

  String _DayKey(DateTime Value) {
    final String Month = Value.month.toString().padLeft(2, '0');
    final String Day = Value.day.toString().padLeft(2, '0');
    return '${Value.year}-$Month-$Day';
  }

  @override
  void dispose() {
    _IsDisposed = true;
    super.dispose();
  }
}
