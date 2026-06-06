import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _channel = MethodChannel('com.example.point_launcher/apps');

final iconCacheProvider =
    StateNotifierProvider<IconCacheNotifier, Map<String, Uint8List?>>((ref) {
  return IconCacheNotifier();
});

class IconCacheNotifier extends StateNotifier<Map<String, Uint8List?>> {
  IconCacheNotifier() : super({});

  Future<Uint8List?> getIcon(String packageName) async {
    if (state.containsKey(packageName)) return state[packageName];

    try {
      final bytes = await _channel
          .invokeMethod<Uint8List>('getAppIcon', {'packageName': packageName});
      state = {...state, packageName: bytes};
      return bytes;
    } catch (_) {
      state = {...state, packageName: null};
      return null;
    }
  }
}
