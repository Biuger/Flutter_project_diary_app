import 'package:http/http.dart' as http;
import 'package:proyecto_flutter/services/EntryChangeNotifier.dart';
import 'dart:convert';
import '../models/diary_entry.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8888/diary_entries';

  EntryChangeNotifier _notifier = EntryChangeNotifier();

  Stream<EntryChangeNotifier> get entryNotifier => _notifier.stream.map((_) => _notifier);

  Future<List<DiaryEntry>> getEntries(int userId) async {
  final Uri url = Uri.parse('$baseUrl?id_user=$userId');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    final List<DiaryEntry> entries = jsonData.map((json) => DiaryEntry.fromJson(json)).toList();
    return entries;
  } else {
    throw Exception('Failed to load entries');
  }
}

  Future<DiaryEntry> createEntry(DiaryEntry entry) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entry.toJson()),
    );
    if (response.statusCode == 200) {
      _notifier.notifyListeners(); 
      return DiaryEntry.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create entry');
    }
  }

  Future<DiaryEntry> updateEntry(int id, DiaryEntry entry) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(entry.toJson()),
    );
    if (response.statusCode == 200) {
      _notifier.notifyListeners(); 
      return DiaryEntry.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No se ha realizado ningún cambio');
    }
  }

  Future<void> deleteEntry(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete entry');
    }
  }
}
