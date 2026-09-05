import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/main.dart';

final syncServiceProvider = StateNotifierProvider<SyncService, AsyncValue<DateTime?>>((ref) {
  return SyncService();
});

class SyncService extends StateNotifier<AsyncValue<DateTime?>> {
  SyncService() : super(const AsyncValue.loading()) {
    _loadLastSyncTime();
  }

  void _loadLastSyncTime() {
    final timestamp = globalPrefs.getInt('last_sync_time');
    if (timestamp != null) {
      state = AsyncValue.data(DateTime.fromMillisecondsSinceEpoch(timestamp));
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> syncData() async {
    state = const AsyncValue.loading();
    // Simulate network delay for syncing
    await Future.delayed(const Duration(seconds: 2));
    
    final now = DateTime.now();
    await globalPrefs.setInt('last_sync_time', now.millisecondsSinceEpoch);
    state = AsyncValue.data(now);
  }
}
