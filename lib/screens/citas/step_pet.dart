import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/screens/app_config.dart';
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
        _buildPetCard(
          "Max",
          "Golden Retriever",
          "4 years old",
          "Male",
          Icons.male,
          "assets/images/dog1.jpg",
        ),
        _buildPetCard(
          "Luna",
          "Tabby Cat",
          "4 years old",
          "Female",
          Icons.female,
          "assets/images/dog2.jpg",
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: selectedPet != null ? widget.onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // 🔹 Aquí controlas el radius
              ),
              elevation: 4,
            ),
            child: Text(
              "CONTINUAR >",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard(
    String name,
    String breed,
    String age,
    String gender,
    IconData genderIcon,
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
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(16),
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${breed} • ${age}",
                style: const TextStyle(color: Colors.black54),
              ),
              Row(
                children: [
                  Icon(
                    genderIcon,
                    color: gender == "Male" ? Colors.blue : Colors.pink,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(gender, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primary)
              : null,
        ),
      ),
    );
  }
}
