import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/suggestion_app.dart';
import 'apps_provider.dart';
import 'nearby_provider.dart';
import 'registration_counts_provider.dart';

const suggestionCount = 5; // 表示するサジェスト数

final suggestionsProvider = FutureProvider<List<SuggestionApp>>((ref) async {
  final nearby = ref.watch(nearbyBindingsProvider).valueOrNull ?? [];

  final counts = ref.watch(registrationCountsProvider).valueOrNull ?? {};
  if (counts.isEmpty) return [];

  final installedApps = ref.watch(installedAppsProvider).valueOrNull ?? [];
  if (installedApps.isEmpty) return [];

  final nearbyPackages = nearby.map((n) => n.binding.packageName).toSet();
  final installedMap = {for (final a in installedApps) a.packageName: a};

  final sorted = counts.entries
      .where((e) => !nearbyPackages.contains(e.key) && installedMap.containsKey(e.key))
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sorted
      .take(suggestionCount)
      .map((e) => SuggestionApp(app: installedMap[e.key]!, registrationCount: e.value))
      .toList();
});
