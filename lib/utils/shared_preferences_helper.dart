
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyHasAgreed = 'hasAgreed';
  static const String _userName = 'userName';

  static Future<bool?> getAgreementStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasAgreed);
  }

  static Future<void> setAgreementStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasAgreed, value);
  }

  static Future<String?> getUserNameStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userName);
  }
  static Future<void> setUserNameStatus(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userName, userName);
  }

}