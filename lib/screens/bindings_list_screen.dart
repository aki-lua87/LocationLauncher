import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:drift/drift.dart' show OrderingTerm, Value;
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../widgets/app_icon.dart';

final _allBindingsProvider = StreamProvider<List<AppBinding>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.appBindings)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

class BindingsListScreen extends ConsumerWidget {
  const BindingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bindingsAsync = ref.watch(_allBindingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('登録済み一覧'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: bindingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (bindings) {
          if (bindings.isEmpty) {
            return const Center(
              child: Text('登録がありません', style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bindings.length,
            itemBuilder: (context, index) =>
                _BindingCard(binding: bindings[index]),
          );
        },
      ),
    );
  }
}

class _BindingCard extends ConsumerWidget {
  final AppBinding binding;
  const _BindingCard({required this.binding});

  Future<void> _openMaps() async {
    final uri = Uri.parse(
        'https://maps.google.com/maps?q=${binding.latitude},${binding.longitude}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _editMemo(BuildContext context, WidgetRef ref) async {
    final controller =
        TextEditingController(text: binding.locationLabel ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('メモを編集'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '例：駅前のコンビニ',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null) {
      final db = ref.read(databaseProvider);
      await (db.update(db.appBindings)..where((t) => t.id.equals(binding.id)))
          .write(AppBindingsCompanion(
        locationLabel:
            Value(result.trim().isEmpty ? null : result.trim()),
      ));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('削除'),
        content: Text('「${binding.appLabel}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('削除', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      await (db.delete(db.appBindings)..where((t) => t.id.equals(binding.id)))
          .go();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUrl = binding.url != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー行
            Row(
              children: [
                isUrl
                    ? _urlIcon()
                    : AppIcon(packageName: binding.packageName, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    binding.appLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                  tooltip: 'メモを編集',
                  onPressed: () => _editMemo(context, ref),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _delete(context, ref),
                ),
              ],
            ),

            // メモ
            if (binding.locationLabel != null &&
                binding.locationLabel!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.notes, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    binding.locationLabel!,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ],

            const Divider(height: 20),

            // 緯度経度
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${binding.latitude.toStringAsFixed(6)}, ${binding.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Googleマップボタン
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.map_outlined, size: 16),
                label: const Text('Googleマップで表示'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _urlIcon() {
    if (binding.iconData != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(binding.iconData!, width: 36, height: 36,
            fit: BoxFit.cover),
      );
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.language, color: Colors.indigo, size: 20),
    );
  }
}
