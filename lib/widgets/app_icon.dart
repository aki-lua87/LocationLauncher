import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/icon_provider.dart';

class AppIcon extends ConsumerStatefulWidget {
  final String packageName;
  final double size;

  const AppIcon({super.key, required this.packageName, this.size = 48});

  @override
  ConsumerState<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends ConsumerState<AppIcon> {
  @override
  void initState() {
    super.initState();
    // キャッシュになければ非同期で取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(iconCacheProvider.notifier).getIcon(widget.packageName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cache = ref.watch(iconCacheProvider);
    final bytes = cache[widget.packageName];

    if (bytes != null) {
      return Image.memory(
        bytes,
        width: widget.size,
        height: widget.size,
        gaplessPlayback: true,
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Icon(Icons.apps, size: widget.size * 0.7, color: Colors.grey[400]),
    );
  }
}
