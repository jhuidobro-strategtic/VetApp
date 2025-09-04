import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/screens/app_config.dart';
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔹 Contenedor principal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appointment Summary",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(thickness: 1, height: 24),

                    _buildInfoRow(
                      Icons.calendar_today,
                      "${model.selectedDate?.toLocal().toString().split(' ')[0]}",
                    ),
                    _buildInfoRow(
                      Icons.access_time,
                      "${model.selectedTime ?? ""} (30 min)",
                    ),
                    _buildInfoRow(
                      Icons.pets,
                      "${model.petName} (${model.petType})",
                    ),
                    _buildInfoRow(
                      Icons.location_on,
                      "PetCare Veterinary Clinic\n123 Main Street, San Francisco, CA",
                    ),

                    const Divider(thickness: 1, height: 32),

                    if (model.symptoms.isNotEmpty) ...[
                      Text(
                        "Symptoms",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: model.symptoms
                            .map(
                              (s) => Chip(
                                label: Text(
                                  s,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                            )
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // 🔹 Contenedor gris para los síntomas
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (model.symptoms.isNotEmpty)
                          //   ...model.symptoms.map(
                          //     (s) => Padding(
                          //       padding: const EdgeInsets.only(bottom: 6),
                          //       child: Text("• $s"),
                          //     ),
                          //   ),
                          if (model.additionalNotes?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Text(
                                model.additionalNotes!,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔹 Botones
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "< BACK",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Appointment Confirmed ✅")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    "CONFIRMAR",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
