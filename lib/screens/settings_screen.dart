import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import 'radius_settings_screen.dart';
import 'bindings_list_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radiusAsync = ref.watch(settingsProvider);
    final currentLabel = radiusAsync.valueOrNull == null
        ? '...'
        : searchRadiusOptions
            .firstWhere(
              (o) => o.value == radiusAsync.value,
              orElse: () => searchRadiusOptions[1],
            )
            .label;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.radar,
            title: '検索半径',
            subtitle: currentLabel,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RadiusSettingsScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.list_alt,
            title: '登録済み一覧',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BindingsListScreen()),
            ),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'ライセンス',
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'ろけらん -LocationLauncher-',
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(icon, color: Colors.indigo),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
