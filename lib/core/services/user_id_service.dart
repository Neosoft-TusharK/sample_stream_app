import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userIdServiceProvider = Provider<UserIdService>((ref) {
  return UserIdService();
});

class UserIdService {
  final _key = 'user_id';

  // Generate random ID
  String _generateRandomId({int length = 8}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  // Get or create stored user ID
  Future<String> getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString(_key);

    if (storedId != null) {
      return storedId;
    }

    final newId = _generateRandomId();
    await prefs.setString(_key, newId);
    return newId;
  }
}
