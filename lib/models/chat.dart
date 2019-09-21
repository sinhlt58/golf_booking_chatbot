class Chat {
  final List<BotResponse> botResponses;

  Chat({this.botResponses});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      botResponses: (json['nlg'] as List)
        .map((i) => BotResponse.fromJson(i))
        .toList(),
    );
  }

}

class BotResponse {
  final String recipientId;
  final String text;
  final String actionName;

  BotResponse({this.recipientId, this.text, this.actionName});
  
  factory BotResponse.fromJson(Map<String, dynamic> json) {
    return BotResponse(
      recipientId: json['recipient_id'],
      text: json['text'],
      actionName: json['action_name'],
    );
  }
}