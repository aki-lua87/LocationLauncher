import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keySearchRadius = 'search_radius';
const double searchRadiusUnlimited = double.infinity;

class SettingsNotifier extends AsyncNotifier<double> {
  @override
  Future<double> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_keySearchRadius);
    return saved ?? 500.0; // デフォルト500m
  }

  Future<void> setSearchRadius(double meters) async {
    final prefs = await SharedPreferences.getInstance();
    if (meters == searchRadiusUnlimited) {
      await prefs.remove(_keySearchRadius);
      state = const AsyncData(searchRadiusUnlimited);
    } else {
      await prefs.setDouble(_keySearchRadius, meters);
      state = AsyncData(meters);
    }
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, double>(SettingsNotifier.new);

const searchRadiusOptions = [
  (label: '100m', value: 100.0),
  (label: '500m', value: 500.0),
  (label: '1km', value: 1000.0),
  (label: '制限なし', value: double.infinity),
];
