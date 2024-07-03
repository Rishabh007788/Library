import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyIsLogin = 'isLogin';
  static const String _keyUserId = 'userId';

  // Save user ID and login status
  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setBool(_keyIsLogin, true);
  }

  // Retrieve user ID
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  // Retrieve login status
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  // Clear session (optional)
  static Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyIsLogin);
  }
}
