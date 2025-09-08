import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/screens/app_config.dart';

class PetDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // 🔹 Cabecera con imagen
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  //bottomLeft: Radius.circular(20),
                  //bottomRight: Radius.circular(20),
                ),
                // pet.photoUrl != null
                //                     ? NetworkImage(pet.photoUrl!)
                //                     : const NetworkImage(
                //                             "http://apivet.strategtic.com/storage/none.jpg",
                child: pet["image"] != null
                    ? Image.network(
                        pet["image"],
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "http://apivet.strategtic.com/storage/none.jpg",
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),

          // 🔹 Contenido
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Información principal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard(Icons.pets, pet["breed"], ""),
                    _buildInfoCard(
                      Icons.monitor_weight,
                      pet["weight"],
                      "Weight",
                    ),
                    _buildInfoCard(Icons.favorite, pet["status"], "Status"),
                  ],
                ),
                const SizedBox(height: 20),

                // Vaccination Status
                Text(
                  "Vaccination Status",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    // children: pet["vaccinations"].map<Widget>((vac) {
                    //   return _buildVaccinationRow(
                    //     vac["name"],
                    //     vac["status"],
                    //     vac["color"],
                    //   );
                    // }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Recent Visits
                Text(
                  "Recent Visits",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  // children: pet["visits"].map<Widget>((visit) {
                  //   return Container(
                  //     margin: const EdgeInsets.only(bottom: 12),
                  //     padding: const EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               visit["title"],
                  //               style: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 15,
                  //               ),
                  //             ),
                  //             Text(
                  //               visit["date"],
                  //               style: GoogleFonts.poppins(
                  //                 color: Colors.grey,
                  //                 fontSize: 12,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(height: 4),
                  //         Text(
                  //           visit["doctor"],
                  //           style: GoogleFonts.poppins(
                  //             color: Colors.black54,
                  //             fontSize: 13,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 6),
                  //         Text(
                  //           visit["notes"],
                  //           style: GoogleFonts.poppins(
                  //             color: Colors.black87,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }).toList(),
                ),
              ],
            ),
          ),

          // 🔹 Botones inferiores
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Book Visit"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(
                      Icons.medical_information,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Medical Records",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget de info principal
  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget para vacunas
  Widget _buildVaccinationRow(String name, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.poppins(fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.poppins(color: color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
