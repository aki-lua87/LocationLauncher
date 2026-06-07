import '../database/database.dart';

class NearbyBinding {
  final AppBinding binding;
  final double distanceMeters;

  const NearbyBinding({required this.binding, required this.distanceMeters});

  String get distanceLabel {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()}m';
    }
    return '${(distanceMeters / 1000).toStringAsFixed(1)}km';
  }
}
