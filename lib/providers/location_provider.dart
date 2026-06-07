import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

// 手動でトリガーするロケーション状態
class LocationNotifier extends AsyncNotifier<Position?> {
  @override
  Future<Position?> build() => _getPosition(); // 起動時に自動取得

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getPosition());
  }

  Future<Position?> _getPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      ).timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }
}

final locationProvider =
    AsyncNotifierProvider<LocationNotifier, Position?>(LocationNotifier.new);
