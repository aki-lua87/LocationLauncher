import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/installed_app.dart';

const _channel = MethodChannel('net.akakitune87.localaun/apps');

final installedAppsProvider = FutureProvider<List<InstalledApp>>((ref) async {
  final List<dynamic> raw = await _channel.invokeMethod('getInstalledApps');
  return raw
      .map((e) => InstalledApp.fromMap(Map<String, dynamic>.from(e as Map)))
      .toList();
});

Future<bool> launchApp(String packageName) async {
  return await _channel.invokeMethod('launchApp', {'packageName': packageName});
}
