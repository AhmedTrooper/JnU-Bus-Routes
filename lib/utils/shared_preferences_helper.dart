import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyHasAgreed = 'hasAgreed';
  static const String _userName = 'userName';
  static const String _busName = 'busName';
  static const String _stoppageName = 'stoppageName';

  static Future<bool?> getAgreementStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasAgreed);
  }

  static Future<void> setAgreementStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasAgreed, value);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userName);
  }

  static Future<void> setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userName, userName);
  }

  static Future<String?> getBusName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_busName);
  }

  static Future<void> setBusName(String busName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_busName, busName);
  }
  static Future<String?> getStoppageName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stoppageName);
  }

  static Future<void> setStoppageName(String stoppageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stoppageName, stoppageName);
  }
}
