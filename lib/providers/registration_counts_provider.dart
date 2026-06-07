import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final registrationCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(databaseProvider);
  final bindings = await db.select(db.appBindings).get();
  final counts = <String, int>{};
  for (final b in bindings) {
    if (b.packageName.isNotEmpty) {
      counts[b.packageName] = (counts[b.packageName] ?? 0) + 1;
    }
  }
  return counts;
});
