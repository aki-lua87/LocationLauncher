import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database.dart';
import '../models/nearby_binding.dart';
import '../providers/apps_provider.dart';
import 'app_icon.dart';

class AppCard extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _launch(context),
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
