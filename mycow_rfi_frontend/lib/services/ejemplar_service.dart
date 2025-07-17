import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mycow_rfi_frontend/models/ejemplar.dart';
import 'package:mycow_rfi_frontend/models/clasificacion.dart';

class EjemplarService {
  final String baseUrl = "http://192.168.1.39:8000/api"; // Asegúrate de que esta URL sea correcta
  final String _token;

  EjemplarService(this._token);

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token',
    };
  }

  Future<List<Ejemplar>> getEjemplares() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ejemplares'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Ejemplar.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load ejemplares: ${response.body}');
    }
  }

  Future<Ejemplar> createEjemplar(Ejemplar ejemplar, {File? imageFile}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/ejemplares'),
    );
    request.headers['Authorization'] = 'Bearer $_token';

    request.fields['codigo_arete'] = ejemplar.codigoArete;
    request.fields['nombre'] = ejemplar.nombre;
    request.fields['fecha_nacimiento'] = ejemplar.fechaNacimiento.toIso8601String().split('T').first;
    request.fields['raza'] = ejemplar.raza;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'foto',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Ejemplar.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to create ejemplar: $responseBody');
    }
  }

  Future<Ejemplar> updateEjemplar(Ejemplar ejemplar, {File? imageFile}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/ejemplares/${ejemplar.id}'),
    );
    request.headers['Authorization'] = 'Bearer $_token';
    request.fields['_method'] = 'PUT'; // Laravel expects _method for PUT with multipart

    request.fields['codigo_arete'] = ejemplar.codigoArete;
    request.fields['nombre'] = ejemplar.nombre;
    request.fields['fecha_nacimiento'] = ejemplar.fechaNacimiento.toIso8601String().split('T').first;
    request.fields['raza'] = ejemplar.raza;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'foto',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Ejemplar.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to update ejemplar: $responseBody');
    }
  }

  Future<void> deleteEjemplar(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ejemplares/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete ejemplar: ${response.body}');
    }
  }

  Future<List<Clasificacion>> getHistorialClasificaciones(int ejemplarId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reportes/historial/$ejemplarId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Clasificacion.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load historial de clasificaciones: ${response.body}');
    }
  }

  Future<String> generatePdfReport(int ejemplarId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reportes/pdf/$ejemplarId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      // En una aplicación real, guardarías el PDF en el dispositivo
      // Por ahora, solo devolvemos la URL o un mensaje de éxito.
      return 'PDF generado con éxito. Descarga iniciada.';
    } else {
      throw Exception('Failed to generate PDF report: ${response.body}');
    }
  }

  Future<String> generateQrCode(int ejemplarId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reportes/qr/$ejemplarId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      // En una aplicación real, mostrarías la imagen QR o la guardarías
      // Por ahora, devolvemos la URL de la imagen QR.
      return '$baseUrl/reportes/qr/$ejemplarId';
    } else {
      throw Exception('Failed to generate QR code: ${response.body}');
    }
  }
}