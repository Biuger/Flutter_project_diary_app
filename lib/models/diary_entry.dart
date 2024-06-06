class DiaryEntry {
  int? id;
  int id_user;
  String title;
  String content;
  String mood;
  DateTime date;

  DiaryEntry({this.id, required this.id_user, required this.title, required this.content, required this.mood, required this.date});

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] != null ? json['id'] as int : null,
      id_user: json['Id_user'] as int,
      title: json['title'],
      content: json['content'],
      mood: json['mood'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Id_user': id_user,
      'title': title,
      'content': content,
      'mood': mood,
      'date': date.toIso8601String(),
    };
  }
}
