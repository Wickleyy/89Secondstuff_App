import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;
  RealtimeChannel? _presenceChannel;
  var onlineUsers = <String>{}.obs;

  User? get currentUser => client.auth.currentUser;

  Future<SupabaseService> init() async {
    try {
      await dotenv.load(fileName: ".env");

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception("Kredensial Supabase tidak ditemukan di .env");
      }
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      client = Supabase.instance.client;
      print('Supabase terinisialisasi!');
    } catch (e) {
      print('!!!!!!!!!!!!!! ERROR INISIALISASI SUPABASE !!!!!!!!!!!!!!');
      print('Error: $e');
      print('Pastikan .env ada di root dan pubspec.yaml assets sudah benar.');
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      rethrow;
    }
    return this;
  }

  void joinPresenceChannel() {
    if (currentUser == null) return;
    
    _presenceChannel = client.channel('online-users');
    
    _presenceChannel!
        .onPresenceSync((_) {
          // Re-sync all presences on sync event
          final presences = _presenceChannel!.presenceState();
          final users = <String>{};
          for (var presence in presences) {
            try {
              // Try to get user_id from different possible structures
              final dynamic presenceMap = presence;
              if (presenceMap is Map) {
                if (presenceMap['user_id'] != null) {
                  users.add(presenceMap['user_id'] as String);
                }
              }
            } catch (_) {}
          }
          onlineUsers.assignAll(users);
        })
        .onPresenceJoin((payload) {
          for (var presence in payload.newPresences) {
            try {
              final dynamic presenceMap = presence;
              if (presenceMap is Map && presenceMap['user_id'] != null) {
                onlineUsers.add(presenceMap['user_id'] as String);
              }
            } catch (_) {}
          }
        })
        .onPresenceLeave((payload) {
          for (var presence in payload.leftPresences) {
            try {
              final dynamic presenceMap = presence;
              if (presenceMap is Map && presenceMap['user_id'] != null) {
                onlineUsers.remove(presenceMap['user_id'] as String);
              }
            } catch (_) {}
          }
        })
        .subscribe((status, error) async {
          if (status == RealtimeSubscribeStatus.subscribed) {
            await _presenceChannel!.track({
              'user_id': currentUser!.id,
              'online_at': DateTime.now().toIso8601String(),
            });
          }
        });
  }

  void leavePresenceChannel() {
    _presenceChannel?.untrack();
    _presenceChannel?.unsubscribe();
    _presenceChannel = null;
  }

  bool isUserOnline(String userId) {
    return onlineUsers.contains(userId);
  }

  @override
  void onClose() {
    leavePresenceChannel();
    super.onClose();
  }
}
