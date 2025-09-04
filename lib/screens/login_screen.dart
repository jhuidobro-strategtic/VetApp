import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_vet_app/screens/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;

  //consumo de api
  Future<void> _login() async {
    final email = _userController.text.trim();
    final password = _passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa email y contraseña")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
        "${AppConfig.baseUrl}/api/v1/login",
      ); // 👈 Cambia {{prod}}
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final userName = data["data"]["user"]["name"];
        final token = data["data"]["access_token"];

        // 👉 Guardar token y baseUrl en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        // 👉 Navegar al HomeContent con el nombre
        Navigator.pushReplacementNamed(context, '/home', arguments: userName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Error en login")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 📌 Imagen arriba
                Image.asset(
                  "assets/images/logo_vetapp_oficial.png",
                  width: 450,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),

                /*
                // 📌 Bienvenida
                Text(
                  "Welcome to",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "VetApp",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(height: 30),
                */

                // 📌 Botón Google
                // 📌 Botón Google con sombra
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    elevation: 3, // 👉 sombra suave
                    borderRadius: BorderRadius.circular(8),
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset("assets/images/google.png", width: 20),
                      label: Text("Login with Google"),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors
                            .white, // 👉 importante para que se note la sombra
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide.none, // 👉 quitamos borde gris
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 📌 Botón Facebook con sombra
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    elevation: 3, // 👉 sombra suave
                    borderRadius: BorderRadius.circular(8),
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/facebook.png",
                        width: 20,
                      ),
                      label: const Text("Login with Facebook"),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📌 Separador con "OR"
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // 📌 Campo Email
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(36, 141, 141, 141),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email, color: Colors.black87),
                      hintText: "example@gmail.com",
                      labelText: "Email",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 📌 Campo Password
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(36, 141, 141, 141),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _passController,
                    obscureText: _obscurePass,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.lock, color: Colors.black87),
                      labelText: "Password",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePass = !_obscurePass;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 📌 Remember me + Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (val) {}),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 📌 Botón Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📌 Registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
