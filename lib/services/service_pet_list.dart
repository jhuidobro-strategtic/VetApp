// lib/services/pet_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_vet_app/screens/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_vet_app/models/pet.dart';

class PetListService {
  final String baseUrl = AppConfig.baseUrl;

  Future<List<Pet>> getPetsByClientId(String clientId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("Token no encontrado. Inicia sesión nuevamente.");
    }

    final url = Uri.parse("$baseUrl/api/v1/getMascotaClienteID/$clientId");
    print("🔹 Consumiento URL: $url"); // Imprimir URL

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print("📥 Código de respuesta: ${response.statusCode}");
    print("📥 Body de respuesta: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        final List<dynamic> petsJson = data["data"];
        return petsJson.map((e) => Pet.fromJson(e)).toList();
      } else {
        throw Exception(data["message"] ?? "Error al obtener mascotas");
      }
    } else {
      throw Exception("Error HTTP: ${response.statusCode}");
    }
  }
}
