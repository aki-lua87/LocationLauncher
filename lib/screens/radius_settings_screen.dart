import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class RadiusSettingsScreen extends ConsumerWidget {
  const RadiusSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radiusAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('検索半径'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: radiusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (currentRadius) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                '現在地からこの距離以内に登録した場所があるアプリを候補に表示します。',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            ...searchRadiusOptions.map((opt) {
              final selected = currentRadius == opt.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: RadioListTile<double>(
                    value: opt.value,
                    groupValue: currentRadius,
                    onChanged: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setSearchRadius(v);
                      }
                    },
                    title: Text(
                      opt.label,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
