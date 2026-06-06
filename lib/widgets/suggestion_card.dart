import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../models/suggestion_app.dart';
import '../providers/database_provider.dart';
import '../providers/nearby_provider.dart';
import 'app_icon.dart';

class SuggestionCard extends ConsumerWidget {
  final SuggestionApp suggestion;

  const SuggestionCard({super.key, required this.suggestion});

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('現在地で登録しますか？'),
        content: Row(
          children: [
            AppIcon(packageName: suggestion.app.packageName, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion.app.appName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('いいえ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('はい'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final db = ref.read(databaseProvider);
      await db.into(db.appBindings).insert(
            AppBindingsCompanion.insert(
              packageName: suggestion.app.packageName,
              appLabel: suggestion.app.appName,
              latitude: position.latitude,
              longitude: position.longitude,
              radiusMeters: const Value(100),
            ),
          );
      ref.invalidate(nearbyBindingsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${suggestion.app.appName}を登録しました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登録に失敗しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.indigo.shade50,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onTap(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                AppIcon(packageName: suggestion.app.packageName, size: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.app.appName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${suggestion.registrationCount}件の登録実績',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.add_location_alt_outlined,
                    color: Colors.indigo.shade300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
