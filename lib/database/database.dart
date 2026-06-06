import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/nearby_binding.dart';

part 'database.g.dart';

class AppBindings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text()();
  TextColumn get appLabel => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get radiusMeters => integer().withDefault(const Constant(100))();
  TextColumn get locationLabel => text().nullable()();
  TextColumn get url => text().nullable()(); // URLバインディング用
  BlobColumn get iconData => blob().nullable()(); // ファビコンキャッシュ
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [AppBindings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(appBindings, appBindings.url);
          }
          if (from < 3) {
            await m.addColumn(appBindings, appBindings.iconData);
          }
        },
      );

  Future<List<NearbyBinding>> getNearbyBindings(
      double lat, double lng, double maxDistanceMeters) async {
    final all = await select(appBindings).get();

    final withDist = all
        .map((b) => (b, _haversineMeters(lat, lng, b.latitude, b.longitude)))
        .where((t) => maxDistanceMeters == double.infinity || t.$2 <= maxDistanceMeters)
        .toList();

    withDist.sort((a, b) => a.$2.compareTo(b.$2));

    // 同じアプリ/URLが複数ある場合はスコア最高の1件だけ残す
    final seen = <String>{};
    return withDist
        .where((t) => seen.add(t.$1.packageName + (t.$1.url ?? '')))
        .map((t) => NearbyBinding(binding: t.$1, distanceMeters: t.$2))
        .toList();
  }

double _haversineMeters(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = _sin2(dLat / 2) +
        _cos(_toRad(lat1)) * _cos(_toRad(lat2)) * _sin2(dLng / 2);
    return 2 * r * _asin(_sqrt(a));
  }

  double _toRad(double deg) => deg * 3.141592653589793 / 180;
  double _sin2(double x) => _sin(x) * _sin(x);
  double _sin(double x) => x - x * x * x / 6;
  double _cos(double x) => 1 - x * x / 2;
  double _asin(double x) => x + x * x * x / 6;
  double _sqrt(double x) {
    if (x <= 0) {
      return 0;
    }
    double r = x;
    for (int i = 0; i < 20; i++) {
      r = (r + x / r) / 2;
    }
    return r;
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'point_launcher.db'));
    return NativeDatabase.createInBackground(file);
  });
}
