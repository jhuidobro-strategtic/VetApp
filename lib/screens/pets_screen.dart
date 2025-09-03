import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_vet_app/models/pet.dart';
import 'package:mobile_vet_app/screens/app_colors.dart';
import 'package:mobile_vet_app/screens/pet_detail_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<Pet> pets = [];
  int _selectedPet = -1; // 🔹 ninguno seleccionado al inicio

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    // 🔹 Simulamos tu JSON
    const jsonResponse = """
    {
      "success": true,
      "message": "Mascotas obtenidas correctamente",
      "data": [
        {
          "PetID": 1,
          "clinicalRecordCode": "COD001",
          "chipNumber": "123",
          "name": "Pako Llatas Bances",
          "birthDate": "02-12-2008",
          "weight": "60 kg",
          "age" : "3 años y 2 meses",
          "reasonForDeactivation": null,
          "deactivationDate": null,
          "healthStatus" : "Healthy",
          "status": "1",
          "client": {
            "id": 1,
            "name": "Osmar Huidobro"
          },
          "species": {
            "speciesID": 1,
            "speciesName": "Dog"
          },
          "breed": {
            "breedID": 5,
            "breedName": "Labrador Retriever"
          },
          "gender": {
            "genderID": 28,
            "genderName": "Male"
          },
          "photo_url":"https://apivet.strategtic.com/storage/mascotas/img_pako-llatas-bances615083.jpeg",
          "createdBy": "1",
          "updatedBy": "1",
          "createdAt": "17-08-2025 02:52:25",
          "updatedAt": "17-08-2025 02:56:05"
        }
      ]
    }
    """;

    final decoded = json.decode(jsonResponse);
    final List data = decoded["data"];
    setState(() {
      pets = data.map((e) => Pet.fromJson(e)).toList();
    });

    //int _selectedPet = 0;

    //final List<Map<String, dynamic>> pets = [
    //{
    //"name": "Max",
    //"breed": "Golden Retriever",
    //"age": "4 years old",
    //"gender": "Male",
    // "genderIcon": Icons.male,
    // "image": "assets/images/dog3.jpg",
    // "weight": "65 lbs",
    // "status": "Healthy",
    // "vaccinations": [
    //   {"name": "Rabies", "status": "Up to date", "color": Colors.green},
    //   {"name": "DHPP", "status": "Up to date", "color": Colors.green},
    //   {"name": "Bordetella", "status": "Due 6/15", "color": Colors.red},
    // ],
    // "visits": [
    //   {
    //     "title": "Annual Checkup",
    //     "date": "Mar 15, 2023",
    //     "doctor": "Dr. James Wilson",
    //     "notes":
    //         "Routine examination, vaccinations updated. Max is in excellent health.",
    //   },
    //   {
    //     "title": "Dental Cleaning",
    //     "date": "Jan 10, 2023",
    //     "doctor": "Dr. Sarah Martinez",
    //     "notes": "Professional dental cleaning completed. No issues found.",
    //   },
    // ],
    //},
    // {
    //   "name": "Luna",
    //   "breed": "French Bulldog",
    //   "age": "2 years old",
    //   "gender": "Female",
    //   "genderIcon": Icons.female,
    //   "image": "assets/images/dog2.jpg",
    // },
    // {
    //   "name": "Rocky",
    //   "breed": "Beagle",
    //   "age": "3 years old",
    //   "gender": "Male",
    //   "genderIcon": Icons.male,
    //   "image": "assets/images/dog3.jpg",
    // },
    //];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose a Pet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          final isSelected = _selectedPet == index; // 🔹 comparación de índice

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
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
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
                    backgroundImage: NetworkImage(pet.photoUrl),
                  ),
                ),
                title: Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${pet.breedName} • ${pet.age}",
                      style: const TextStyle(color: Colors.black54),
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
                          pet.genderName == "Male" ? Icons.male : Icons.female,
                          color: pet.genderName == "Male"
                              ? Colors.blue
                              : Colors.pink,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet.genderName,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: isSelected
                    ? const CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
