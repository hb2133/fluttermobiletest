import 'package:shared_preferences/shared_preferences.dart';

class RockCareSnapshot {
  final int TotalPolish;
  final int DailyPolish;
  final String? LastPettedDay;

  const RockCareSnapshot({
    required this.TotalPolish,
    required this.DailyPolish,
    required this.LastPettedDay,
  });
}

class RockCareAction {
  static const String _TotalPolishKey = 'screen_rock.total_polish';
  static const String _DailyPolishKey = 'screen_rock.daily_polish';
  static const String _LastPettedDayKey = 'screen_rock.last_petted_day';
  static const String _LegacyTotalPetsKey = 'screen_rock.total_pets';
  static const String _LegacyDailyPetsKey = 'screen_rock.daily_pets';
  static const String _LegacyShineDaysKey = 'screen_rock.shine_days';

  Future<RockCareSnapshot> Load() async {
    final SharedPreferences Preferences = await SharedPreferences.getInstance();
    final String? LastPettedDay = Preferences.getString(_LastPettedDayKey);
    final int LegacyTotalPets =
        Preferences.getInt(_LegacyTotalPetsKey) ??
        Preferences.getInt(_LegacyShineDaysKey) ??
        0;
    final int LegacyDailyPets =
        Preferences.getInt(_LegacyDailyPetsKey) ??
        (LastPettedDay == null ? 0 : LegacyTotalPets.clamp(0, 1));

    return RockCareSnapshot(
      TotalPolish:
          Preferences.getInt(_TotalPolishKey) ?? (LegacyTotalPets * 100),
      DailyPolish:
          Preferences.getInt(_DailyPolishKey) ?? (LegacyDailyPets * 100),
      LastPettedDay: LastPettedDay,
    );
  }

  Future<void> Save(RockCareSnapshot Snapshot) async {
    final SharedPreferences Preferences = await SharedPreferences.getInstance();
    await Preferences.setInt(_TotalPolishKey, Snapshot.TotalPolish);
    await Preferences.setInt(_DailyPolishKey, Snapshot.DailyPolish);
    if (Snapshot.LastPettedDay != null) {
      await Preferences.setString(_LastPettedDayKey, Snapshot.LastPettedDay!);
    }
  }

  Future<void> Reset() async {
    final SharedPreferences Preferences = await SharedPreferences.getInstance();
    for (final String Key in <String>[
      _TotalPolishKey,
      _DailyPolishKey,
      _LastPettedDayKey,
      _LegacyTotalPetsKey,
      _LegacyDailyPetsKey,
      _LegacyShineDaysKey,
    ]) {
      await Preferences.remove(Key);
    }
  }
}
