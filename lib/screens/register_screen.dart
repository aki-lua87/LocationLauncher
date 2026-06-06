import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart' show Value;
import '../database/database.dart';
import '../models/installed_app.dart';
import '../providers/database_provider.dart';
import '../providers/apps_provider.dart';
import '../providers/registration_counts_provider.dart';
import '../widgets/app_icon.dart';
import '../utils/favicon_fetcher.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String? sharedUrl;

  const RegisterScreen({super.key, this.sharedUrl});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final int _radius = 100;
  String _query = '';
  late final TextEditingController _urlLabelController;

  bool get _isUrlMode => widget.sharedUrl != null;

  @override
  void initState() {
    super.initState();
    _urlLabelController = TextEditingController();
  }

  @override
  void dispose() {
    _urlLabelController.dispose();
    super.dispose();
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<void> _registerApp(InstalledApp app, String memo) async {
    if (!await _requestLocationPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('位置情報の権限を許可してください')),
        );
      }
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    final db = ref.read(databaseProvider);
    await db.into(db.appBindings).insert(
          AppBindingsCompanion.insert(
            packageName: app.packageName,
            appLabel: app.appName,
            latitude: position.latitude,
            longitude: position.longitude,
            radiusMeters: Value(_radius),
            locationLabel: Value(memo.trim().isEmpty ? null : memo.trim()),
          ),
        );
  }

  Future<void> _registerUrl(String label) async {
    if (label.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('名前を入力してください')),
        );
      }
      return;
    }
    if (!await _requestLocationPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('位置情報の権限を許可してください')),
        );
      }
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    final favicon = await fetchFavicon(widget.sharedUrl!);
    final db = ref.read(databaseProvider);
    await db.into(db.appBindings).insert(
          AppBindingsCompanion.insert(
            packageName: '',
            appLabel: label.trim(),
            latitude: position.latitude,
            longitude: position.longitude,
            radiusMeters: Value(_radius),
            url: Value(widget.sharedUrl),
            iconData: Value(favicon),
          ),
        );
  }

  void _showAppRegisterModal(BuildContext context, InstalledApp app) {
    final memoController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AppRegisterModal(
        app: app,
        memoController: memoController,
        onRegister: (memo) async {
          try {
            await _registerApp(app, memo);
            if (ctx.mounted) Navigator.pop(ctx);
            if (mounted) Navigator.pop(context);
          } catch (e) {
            if (ctx.mounted) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text('登録に失敗しました: $e')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isUrlMode) return _buildUrlMode();
    return _buildAppMode();
  }

  Widget _buildUrlMode() {
    bool loading = false;
    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
        appBar: AppBar(
          title: const Text('URLを登録'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.sharedUrl!,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel('名前'),
            const SizedBox(height: 8),
            TextField(
              controller: _urlLabelController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '例：楽天ポイントクラブ',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() => loading = true);
                        try {
                          await _registerUrl(_urlLabelController.text);
                          if (mounted) Navigator.pop(context);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('登録に失敗しました: $e')),
                            );
                          }
                        } finally {
                          setState(() => loading = false);
                        }
                      },
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: const Text('現在地で登録', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppMode() {
    final appsAsync = ref.watch(installedAppsProvider);
    final counts = ref.watch(registrationCountsProvider).valueOrNull ?? {};

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('アプリを登録'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'アプリを検索',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: appsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('アプリ一覧の取得に失敗しました: $e')),
        data: (apps) {
          final filtered = apps
              .where((a) =>
                  a.appName.toLowerCase().contains(_query.toLowerCase()))
              .toList()
            ..sort((a, b) {
              final ca = counts[a.packageName] ?? 0;
              final cb = counts[b.packageName] ?? 0;
              if (cb != ca) return cb.compareTo(ca);
              return a.appName.compareTo(b.appName);
            });

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final app = filtered[index];
              final count = counts[app.packageName] ?? 0;
              return ListTile(
                leading: AppIcon(packageName: app.packageName, size: 40),
                title: Text(app.appName,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: count > 0
                    ? Text(
                        '$count件登録済み',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : null,
                onTap: () => _showAppRegisterModal(context, app),
              );
            },
          );
        },
      ),
    );
  }
}

class _AppRegisterModal extends StatefulWidget {
  final InstalledApp app;
  final TextEditingController memoController;
  final Future<void> Function(String memo) onRegister;

  const _AppRegisterModal({
    required this.app,
    required this.memoController,
    required this.onRegister,
  });

  @override
  State<_AppRegisterModal> createState() => _AppRegisterModalState();
}

class _AppRegisterModalState extends State<_AppRegisterModal> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: const BoxConstraints(minHeight: 320),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              AppIcon(packageName: widget.app.packageName, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.app.appName,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'を現在地に登録します',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: widget.memoController,
            decoration: InputDecoration(
              hintText: 'メモ（任意）例：駅前のコンビニ',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      await widget.onRegister(widget.memoController.text);
                      if (mounted) setState(() => _loading = false);
                    },
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
              label: const Text('現在地で登録', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }
}
