import 'package:http/http.dart' as http;
import 'package:proyecto_flutter/models/user_model.dart';
import 'dart:convert';

class UserService {
  final String baseUrl = 'http://10.0.2.2:8888/users';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<User> users = jsonData.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUserByEmailAndPassword(String email, String password) async {
  final response = await http.get(
    Uri.parse('$baseUrl/$email'),
  );
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Usuario o contraseña incorrectos');
  }
}

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
