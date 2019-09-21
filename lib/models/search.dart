class Search {
  final String intent;
  final num confidence;
  final List<Entity> entities;
  final List<String> tokens;

  Search({this.intent, this.confidence, this.entities, this.tokens});

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      intent: json['rasa_intent']["intent"]["name"],
      confidence: json['rasa_intent']['intent']['confidence'],
      entities: (json['rasa_ner']['merged_entities'] as List)
          .map((i) => Entity.fromJson(i))
          .toList(),
      tokens: (json['rasa_ner']['tokens'] as List)
          .map((i) => i.toString())
          .toList(),
    );
  }
}

class Entity {
  final String name;
  final String value;
  final String resolution;
  final num start;
  final num end;
  final String text;
  final String entity;
  final String entityType;
  final String extractor;
  final num confidence;

  Entity(
      {this.name,
      this.value,
      this.resolution,
      this.start,
      this.end,
      this.text,
      this.entity,
      this.entityType,
      this.extractor,
      this.confidence});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      name: json['entity'],
      value: json['value'].toString(),
      resolution: json['resolution'],
      start: json['start'],
      end: json['end'],
      text: json['text'],
      entity: json['entity'],
      entityType: json['entity_type'],
      extractor: json['extractor'],
      confidence: json['confidence'],
    );
  }
}
