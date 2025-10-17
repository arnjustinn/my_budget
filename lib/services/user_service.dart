import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const _usersKey = 'registered_users';

  /// Registers a new user with username and password.
  /// Returns true if successful, false if username already exists.
  Future<bool> registerUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    Map<String, String> users = {};

    if (usersJson != null) {
      users = Map<String, String>.from(jsonDecode(usersJson));
    }

    if (users.containsKey(username)) {
      // Username already taken
      return false;
    }

    // For production, hash the password before saving!
    users[username] = password;
    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  /// Attempts to log in user by username and password.
  /// Returns true if credentials are correct.
  Future<bool> loginUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return false;

    final users = Map<String, String>.from(jsonDecode(usersJson));
    if (!users.containsKey(username)) return false;

    return users[username] == password;
  }

  /// Optional: Clear all users (for testing)
  Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}
