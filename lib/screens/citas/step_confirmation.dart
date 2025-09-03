import 'package:flutter/material.dart';
import 'appointment_model.dart';

class StepConfirmation extends StatelessWidget {
  final VoidCallback onBack;
  final AppointmentModel model;

  const StepConfirmation({
    super.key,
    required this.onBack,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Appointment Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.lightBlue),
                  title: const Text("Dr. James Wilson"),
                  subtitle: const Text("Veterinary Checkup"),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.calendar_today,
                "${model.selectedDate?.toLocal().toString().split(' ')[0]}",
              ),
              _buildInfoRow(
                Icons.access_time,
                "${model.selectedTime ?? ""} (30 min)",
              ),
              _buildInfoRow(Icons.pets, "${model.petName} (${model.petType})"),
              _buildInfoRow(
                Icons.location_on,
                "PetCare Veterinary Clinic\n123 Main Street, San Francisco, CA",
              ),
              const SizedBox(height: 16),
              if (model.symptoms.isNotEmpty) ...[
                const Text(
                  "Symptoms:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: model.symptoms
                      .map(
                        (s) => Chip(
                          label: Text(s),
                          backgroundColor: Colors.lightBlue.shade50,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (model.additionalNotes?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Text(model.additionalNotes!),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <- radius aquí
                    ),
                  ),
                  child: const Text("BACK"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Acción final: Confirmar cita
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Appointment Confirmed ✅")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      // 🔹 Aquí controlas el radius
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "CONFIRMAR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.lightBlue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
