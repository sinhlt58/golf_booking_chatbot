import 'package:golf_booking_chatbot/models/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ConfigData> getConfigData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String domain = prefs.getString('domain') ?? "https://www.botcuaban.com";
  final String userId = prefs.getString('userId') ?? "golf_prototype@gmail.com";
  return ConfigData(domain: domain, userId: userId);
}

Future<void> setConfigData(ConfigData configData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', configData.userId);
  prefs.setString('domain', configData.domain);
}