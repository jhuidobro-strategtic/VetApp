import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_vet_app/models/maestros.dart';
import 'package:mobile_vet_app/screens/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //final String baseUrl;
  //final String token;

  //ApiService({required this.baseUrl, required this.token});

  Future<List<MaestroTipo>> getMaestroTipos(int tipoId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    //final baseUrl = prefs.getString("baseUrl") ?? "";
    final baseUrl = AppConfig.baseUrl;

    final url = Uri.parse('$baseUrl/api/v1/getDatosMaestroTipoID/$tipoId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((item) => MaestroTipo.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener MaestroTipo: ${response.body}');
    }
  }
}
