import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop/User/User.dart';

class RegistrationPageService{
  final String _URL = "https://22084nhw-8080.euw.devtunnels.ms/api/users";

  Future<void> saveUser(String name, String nickname, String password, String email) async {
    final response = await http.post(
      Uri.parse(_URL + "/create"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode({
        "id": null,
        "name": name,
        "nickname": nickname,
        "password": password,
        "email": email
      }),
    );
    if(response.statusCode == 201){
      return;
    }
    else{
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Unknown error occurred');
    }
  }

  Future<User> findByEmail(String email) async {
    final uri = Uri.parse(_URL + "/search").replace(queryParameters: {'email': email});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json.isEmpty) {
        throw Exception('User not found');
      }
      return User.fromJson(json);
    } 
    else if (response.statusCode == 404) {
      throw Exception('User with this email not found');
    }
    else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to fetch user');
    }
  }

  Future<void> deleteUser(int? id) async {
    http.delete(
      Uri.parse(_URL + "/${id}")
    );
  }
}