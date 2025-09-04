import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_vet_app/screens/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetService {
  Future<Map<String, dynamic>> registerPet({
    required String clientID,
    required String name,
    required String specie,
    required String gender,
    required String breed,
    required String birthDate,
    required String weight,
    required File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("No hay token guardado. Inicia sesión primero.");
    }

    final url = Uri.parse("${AppConfig.baseUrl}/api/v1/registerMascota");

    var request = http.MultipartRequest("POST", url);

    // Headers con token
    request.headers["Authorization"] = "Bearer $token";

    // Campos
    request.fields["ClienteID"] = clientID;
    request.fields["Nombre"] = name;
    request.fields["Especie"] = specie;
    request.fields["Genero"] = gender;
    request.fields["Raza"] = breed;
    request.fields["fchNacimiento"] = birthDate;
    request.fields["peso"] = weight;

    // Imagen (opcional)
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("photo", imageFile.path),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return {"success": true, "body": responseBody};
    } else {
      return {"success": false, "body": responseBody};
    }
  }
}
