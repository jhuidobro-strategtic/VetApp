import 'package:flutter/material.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  int _selectedPet = 0;

  final List<Map<String, dynamic>> pets = [
    {
      "name": "Max",
      "breed": "Golden Retriever",
      "age": "4 years old",
      "gender": "Male",
      "genderIcon": Icons.male,
      "image": "assets/images/dog1.jpg",
    },
    {
      "name": "Luna",
      "breed": "French Bulldog",
      "age": "2 years old",
      "gender": "Female",
      "genderIcon": Icons.female,
      "image": "assets/images/dog2.jpg",
    },
    {
      "name": "Rocky",
      "breed": "Beagle",
      "age": "3 years old",
      "gender": "Male",
      "genderIcon": Icons.male,
      "image": "assets/images/dog3.jpg",
    },
  ];

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
          final isSelected = _selectedPet == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPet = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? Colors.deepPurpleAccent
                      : Colors.grey.shade300,
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
                    backgroundImage: AssetImage(pet["image"]),
                  ),
                ),
                title: Text(
                  pet["name"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${pet["breed"]} • ${pet["age"]}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Row(
                      children: [
                        Icon(
                          pet["genderIcon"],
                          color: pet["gender"] == "Male"
                              ? Colors.blue
                              : Colors.pink,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet["gender"],
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: isSelected
                    ? const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.deepPurpleAccent,
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
