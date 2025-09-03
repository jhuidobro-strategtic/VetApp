import 'package:flutter/material.dart';
import 'appointment_model.dart';

class StepPet extends StatefulWidget {
  final VoidCallback onNext;
  final AppointmentModel model;

  const StepPet({super.key, required this.onNext, required this.model});

  @override
  State<StepPet> createState() => _StepPetState();
}

class _StepPetState extends State<StepPet> {
  String? selectedPet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose a Pet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        _buildPetCard("Max", "Golden Retriever", 4, "Male", "assets/dog.png"),
        _buildPetCard("Luna", "Tabby Cat", 2, "Female", "assets/cat.png"),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: selectedPet != null ? widget.onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // 🔹 Aquí controlas el radius
              ),
              elevation: 4,
            ),
            child: const Text(
              "CONTINUAR >",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard(
    String name,
    String breed,
    int age,
    String gender,
    String imagePath,
  ) {
    final isSelected = selectedPet == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPet = name;
          widget.model.petName = name;
          widget.model.petType = breed;
          widget.model.petAge = age;
          widget.model.gender = gender;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? Colors.deepPurpleAccent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("$breed • $age years old\n$gender"),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.deepPurpleAccent)
              : null,
        ),
      ),
    );
  }
}
