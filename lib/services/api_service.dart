import 'dart:convert';
import 'package:golf_booking_chatbot/models/chat.dart';
import 'package:golf_booking_chatbot/models/config.dart';
import 'package:golf_booking_chatbot/models/search.dart';
import 'package:golf_booking_chatbot/services/local_service.dart';
import 'package:http/http.dart' as http;

Future<Search> search(String text) async {
  final ConfigData configData = await getConfigData();
  final url = configData.domain + "/api/v1/bots/golf_searching/chat";
  final response =
    await http.post(
      url,
      body: json.encode({"text": text})
    );

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return Search.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<Chat> chat(String text) async {
  final ConfigData configData = await getConfigData();
  final url = configData.domain + "/api/v1/bots/golf_booking_client/chat";
  final response =
    await http.post(
      url,
      body: json.encode({"text": text, "user_id": configData.userId})
    );

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return Chat.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
