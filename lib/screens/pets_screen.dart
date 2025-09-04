import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/models/pet.dart';
import 'package:mobile_vet_app/screens/add_pet_screen.dart';
import 'package:mobile_vet_app/screens/app_config.dart';
import 'package:mobile_vet_app/screens/pet_detail_screen.dart';
import 'package:mobile_vet_app/services/service_pet_list.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final PetListService _petListService = PetListService();
  List<Pet> pets = [];
  int _selectedPet = -1; // 🔹 ninguno seleccionado al inicio
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final result = await _petListService.getPetsByClientId(
        "2",
      ); // 👈 id cliente dinámico
      setState(() {
        pets = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error cargando mascotas: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose a Pet",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
          ? const Center(child: Text("No hay mascotas registradas"))
          : Column(
              children: [
                // 🔹 Listado de mascotas
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      final isSelected =
                          _selectedPet == index; // 🔹 comparación de índice

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPet = index; // 🔹 marcamos la selección
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PetDetailScreen(
                                pet: {
                                  "name": pet.name,
                                  "breed": pet.breedName,
                                  "age": pet.age,
                                  "gender": pet.genderName,
                                  "image": pet.photoUrl,
                                  "weight": pet.weight,
                                  "status": pet.healthStatus,
                                },
                              ),
                            ),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              //color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: SizedBox(
                              width: 60, // ancho del contenedor
                              height: 60, // alto del contenedor
                              child: CircleAvatar(
                                backgroundImage: pet.photoUrl != null
                                    ? NetworkImage(pet.photoUrl!)
                                    : const NetworkImage(
                                            "http://apivet.strategtic.com/storage/none.jpg",
                                          )
                                          as ImageProvider,
                              ),
                            ),
                            title: Text(
                              pet.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${pet.breedName} • ${pet.age}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black54,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Icon(
                                    //   pet["genderIcon"],
                                    //   color: pet["gender"] == "Male"
                                    //       ? Colors.blue
                                    //       : Colors.pink,
                                    //   size: 16,
                                    // ),
                                    Icon(
                                      pet.genderName == "Macho"
                                          ? Icons.male
                                          : Icons.female,
                                      color: pet.genderName == "Macho"
                                          ? Colors.blue
                                          : Colors.pink,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      pet.genderName,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: isSelected
                                ? const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.primary,
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // 🔹 Texto "Add New Pet"
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddPetScreen()),
                      );
                    },
                    child: Text(
                      "Add New Pet",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
