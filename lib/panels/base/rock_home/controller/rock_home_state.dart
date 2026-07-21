import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_types.dart';

class RockHomeState {
  final int TotalPolish;
  final int TodayPolish;
  final String? LastPettedDay;
  final bool IsLoading;
  final bool IsPetting;
  final int ReactionToken;

  const RockHomeState({
    required this.TotalPolish,
    required this.TodayPolish,
    required this.LastPettedDay,
    required this.IsLoading,
    required this.IsPetting,
    required this.ReactionToken,
  });

  factory RockHomeState.Initial() {
    return const RockHomeState(
      TotalPolish: 0,
      TodayPolish: 0,
      LastPettedDay: null,
      IsLoading: true,
      IsPetting: false,
      ReactionToken: 0,
    );
  }

  double get Shine =>
      (TotalPolish / RockCarePolicy.FullShinePolish).clamp(0, 1);

  double get DailyProgress =>
      (TodayPolish / RockCarePolicy.DailyPolishTarget).clamp(0, 1);

  bool get IsDailyLimitReached =>
      TodayPolish >= RockCarePolicy.DailyPolishTarget;

  RockHomeState CopyWith({
    int? TotalPolish,
    int? TodayPolish,
    String? LastPettedDay,
    bool? IsLoading,
    bool? IsPetting,
    int? ReactionToken,
  }) {
    return RockHomeState(
      TotalPolish: TotalPolish ?? this.TotalPolish,
      TodayPolish: TodayPolish ?? this.TodayPolish,
      LastPettedDay: LastPettedDay ?? this.LastPettedDay,
      IsLoading: IsLoading ?? this.IsLoading,
      IsPetting: IsPetting ?? this.IsPetting,
      ReactionToken: ReactionToken ?? this.ReactionToken,
    );
  }
}
