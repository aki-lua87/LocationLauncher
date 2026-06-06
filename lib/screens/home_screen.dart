import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nearby_provider.dart';
import '../providers/location_provider.dart';
import '../providers/suggestions_provider.dart' show suggestionsProvider;
import '../widgets/app_card.dart';
import '../widgets/suggestion_card.dart';
import 'register_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationProvider);
    final nearbyAsync = ref.watch(nearbyBindingsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('ろけらん'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: locationAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('位置情報を取得中...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        error: (e, _) => _buildIdle(context, ref, error: '位置情報の取得に失敗しました'),
        data: (position) {
          if (position == null) {
            return _buildIdle(context, ref);
          }
          return nearbyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _buildIdle(context, ref, error: 'エラーが発生しました'),
            data: (bindings) {
              final suggestions =
                  ref.watch(suggestionsProvider).valueOrNull ?? [];
              final showSuggestions = suggestions.isNotEmpty;

              if (bindings.isEmpty && !showSuggestions) {
                return _buildEmpty(context, ref);
              }

              return RefreshIndicator(
                onRefresh: () => ref.read(locationProvider.notifier).fetch(),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16, 16, 16,
                    80 + MediaQuery.of(context).padding.bottom,
                  ),
                  children: [
                    ...bindings.map((nearby) => AppCard(
                          nearby: nearby,
                          onLaunch: () {},
                        )),
                    if (showSuggestions) ...[
                      if (bindings.isNotEmpty) const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'よく使うアプリ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      ...suggestions.map((s) => SuggestionCard(suggestion: s)),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('登録'),
      ),
    );
  }

  Widget _buildIdle(BuildContext context, WidgetRef ref, {String? error}) {
    return RefreshIndicator(
      onRefresh: () => ref.read(locationProvider.notifier).fetch(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  error != null ? Icons.location_off : Icons.location_searching,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  error ?? '下に引っ張って更新',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.credit_card_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '近くに登録されたアプリはありません',
            style: TextStyle(color: Colors.grey[600], fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            '右下の「登録」から追加してください',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
