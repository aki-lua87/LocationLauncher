import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database.dart';
import '../models/nearby_binding.dart';
import '../providers/apps_provider.dart';
import '../providers/database_provider.dart';
import 'app_icon.dart';

class AppCard extends ConsumerWidget {
  final NearbyBinding nearby;
  final VoidCallback onLaunch;

  const AppCard({super.key, required this.nearby, required this.onLaunch});

  AppBinding get binding => nearby.binding;

  Future<void> _launch(BuildContext context) async {
    if (binding.url != null) {
      final uri = Uri.tryParse(binding.url!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${binding.appLabel}を開けませんでした')),
        );
      }
      onLaunch();
      return;
    }

    final launched = await launchApp(binding.packageName);
    if (!launched) {
      final uri = Uri.parse('market://details?id=${binding.packageName}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${binding.appLabel}を起動できませんでした')),
        );
      }
    }
    onLaunch();
  }

  Future<void> _openAppInfo(BuildContext context) async {
    final uri = Uri.parse('market://details?id=${binding.packageName}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final fallback = Uri.parse(
          'https://play.google.com/store/apps/details?id=${binding.packageName}');
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
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
            child: const Text('削除', style: TextStyle(color: Colors.white)),
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

  void _showContextMenu(BuildContext context, WidgetRef ref) {
    final isUrl = binding.url != null;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    isUrl
                        ? _FaviconIcon(iconData: binding.iconData)
                        : AppIcon(packageName: binding.packageName, size: 36),
                    const SizedBox(width: 12),
                    Text(
                      binding.appLabel,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('開く'),
                onTap: () {
                  Navigator.pop(ctx);
                  _launch(context);
                },
              ),
              if (!isUrl)
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('アプリ情報'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openAppInfo(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('削除', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  _delete(context, ref);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _launch(context),
          onLongPress: () => _showContextMenu(context, ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                binding.url != null
                    ? _FaviconIcon(iconData: binding.iconData)
                    : AppIcon(packageName: binding.packageName, size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        binding.appLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nearby.distanceLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaviconIcon extends StatelessWidget {
  final Uint8List? iconData;

  const _FaviconIcon({this.iconData});

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(iconData!, width: 48, height: 48, fit: BoxFit.cover),
      );
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.language, color: Colors.indigo),
    );
  }
}
