import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as server;

import '../utils/client.dart';

class MySQL {
  static final MySQL _singleton = MySQL._internal();

  factory MySQL() {
    return _singleton;
  }

  MySQL._internal();

  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<List<Client>> getAll() async {
    final response = await server.get(Uri.parse('$_baseUrl?get_all'));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final clients = List<Map<String, dynamic>>.from(responseBody)
          .map((client) => Client.fromJson(client))
          .toList();
      return clients;
    } else {
      throw Exception('Failed to load clients from server');
    }
  }

  Future<Client> getById(int id) async {
    final response = await server.get(Uri.parse('$_baseUrl?id=$id'));
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final client = Client.fromJson(Map<String, dynamic>.from(responseBody));
      return client;
    } else {
      throw Exception('Failed to load client from server');
    }
  }

  Future<void> create(Client client) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'name': client.name, 'age': client.age});
    final response =
        await server.post(Uri.parse(_baseUrl), headers: headers, body: body);
    if (response.statusCode != 201) {
      throw Exception('Failed to add client to server');
    }
  }

  Future<void> update(int id, Client client) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'name': client.name, 'age': client.age});
    final response = await server.put(Uri.parse('$_baseUrl?id=$id'),
        headers: headers, body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to update client on server');
    }
  }

  Future<void> delete(int id) async {
    final response = await server.delete(Uri.parse('$_baseUrl?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete client from server');
    }
  }
}
