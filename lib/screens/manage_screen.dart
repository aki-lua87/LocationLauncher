import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value, OrderingTerm;
import '../database/database.dart';
import '../providers/database_provider.dart';
import '../widgets/app_icon.dart';

final allBindingsProvider = StreamProvider<List<AppBinding>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.appBindings)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

class ManageScreen extends ConsumerWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bindingsAsync = ref.watch(allBindingsProvider);

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
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (bindings) {
          if (bindings.isEmpty) {
            return const Center(
              child: Text('登録がありません', style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bindings.length,
            itemBuilder: (context, index) {
              final b = bindings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: AppIcon(packageName: b.packageName, size: 36),
                  title: Text(b.appLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (b.locationLabel != null)
                        Text(b.locationLabel!,
                            style: const TextStyle(fontSize: 12)),
                      Text(
                        '使用 ${b.usageCount}回',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        _showEditDialog(context, ref, b);
                      } else if (value == 'delete') {
                        final db = ref.read(databaseProvider);
                        await (db.delete(db.appBindings)
                              ..where((t) => t.id.equals(b.id)))
                            .go();
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('編集')),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Text('削除', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, AppBinding binding) {
    final labelController =
        TextEditingController(text: binding.locationLabel ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(binding.appLabel),
        content: TextField(
          controller: labelController,
          decoration: const InputDecoration(labelText: '店舗名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await (db.update(db.appBindings)
                    ..where((t) => t.id.equals(binding.id)))
                  .write(AppBindingsCompanion(
                locationLabel: Value(labelController.text.isEmpty
                    ? null
                    : labelController.text),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
