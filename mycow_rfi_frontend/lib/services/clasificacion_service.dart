import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mycow_rfi_frontend/models/clasificacion.dart';

class ClasificacionService {
  final String baseUrl = "http://192.168.1.39:8000/api"; // Asegúrate de que esta URL sea correcta
  final String _token;

  ClasificacionService(this._token);

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token',
    };
  }

  Future<Clasificacion> createClasificacion(Map<String, dynamic> clasificacionData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clasificaciones'),
      headers: _getHeaders(),
      body: jsonEncode(clasificacionData),
    );

    if (response.statusCode == 201) {
      return Clasificacion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create clasificacion: ${response.body}');
    }
  }

  Future<List<Clasificacion>> getClasificaciones({int? ejemplarId}) async {
    String url = '$baseUrl/clasificaciones';
    if (ejemplarId != null) {
      url += '?ejemplar_id=$ejemplarId';
    }
    final response = await http.get(
      Uri.parse(url),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Clasificacion.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load clasificaciones: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getParametrosPorRaza(String raza) async {
    final response = await http.get(
      Uri.parse('$baseUrl/parametros-por-raza/$raza'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load parametros por raza: ${response.body}');
    }
  }
}