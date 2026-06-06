import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../models/nearby_binding.dart';
import 'database_provider.dart';
import 'location_provider.dart';
import 'settings_provider.dart';

final nearbyBindingsProvider = FutureProvider<List<NearbyBinding>>((ref) async {
  final position = ref.watch(locationProvider).valueOrNull;
  if (position == null) return [];
  final radius = ref.watch(settingsProvider).valueOrNull ?? 500.0;
  final db = ref.watch(databaseProvider);
  return db.getNearbyBindings(position.latitude, position.longitude, radius);
});
