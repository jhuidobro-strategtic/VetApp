import 'package:flutter/material.dart';
import 'appointment_model.dart';
import 'step_pet.dart';
import 'step_symptoms.dart';
import 'step_date_time.dart';
import 'step_confirmation.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  int currentStep = 0;
  final AppointmentModel appointment = AppointmentModel();

  void nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      StepPet(onNext: nextStep, model: appointment),
      StepSymptoms(onNext: nextStep, onBack: previousStep, model: appointment),
      StepDateTime(onNext: nextStep, onBack: previousStep, model: appointment),
      StepConfirmation(onBack: previousStep, model: appointment),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        //centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: IndexedStack(index: currentStep, children: steps),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final titles = ["Pet", "Symptoms", "Date & Time", "Confirm"];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(titles.length, (index) {
          bool isActive = index == currentStep;
          bool isCompleted = index < currentStep;

          return Column(
            children: [
              CircleAvatar(
                backgroundColor: isCompleted || isActive
                    ? Colors.deepPurpleAccent
                    : Colors.grey.shade300,
                child: Icon(_getIcon(index), color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                titles[index],
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.deepPurpleAccent : Colors.grey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.pets;
      case 1:
        return Icons.healing;
      case 2:
        return Icons.calendar_today;
      case 3:
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }
}
