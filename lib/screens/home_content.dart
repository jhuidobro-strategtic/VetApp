import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/screens/pets_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userName != null ? "¡Hola, $userName!" : "Hola!",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        //backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card grande
              GestureDetector(
                onTap: () {
                  // Ir a Citas
                  /*
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Ir a Citas")));
                */
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PetsScreen()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/img1.png",
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Mis mascotas",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 115, 115, 115),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  // Ir a Citas
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Ir a Citas")));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/img2.png",
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Nuevas Solicitudes de citas",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 115, 115, 115),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Cards pequeños (en Row)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ir a Agenda")),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.asset(
                                "assets/images/img3.png",
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Citas agendadas",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(
                                    255,
                                    115,
                                    115,
                                    115,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ir a Historial")),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.asset(
                                "assets/images/img4.png",
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Historial de citas",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(
                                    255,
                                    115,
                                    115,
                                    115,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Card adicional inferior
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ir a Configuración")),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: const Text("Configurar zona de domicilios"),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
