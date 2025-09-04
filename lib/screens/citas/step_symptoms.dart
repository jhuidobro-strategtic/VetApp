import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/screens/app_config.dart';
import 'appointment_model.dart';

class StepSymptoms extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final AppointmentModel model;

  const StepSymptoms({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.model,
  });

  @override
  State<StepSymptoms> createState() => _StepSymptomsState();
}

class _StepSymptomsState extends State<StepSymptoms> {
  final List<String> allSymptoms = [
    "Decreased appetite",
    "Lethargy/weakness",
    "Vomiting",
    "Diarrhea",
    "Coughing",
    "Itching/skin issues",
  ];

  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notesController.text = widget.model.additionalNotes ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Symptoms",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ...allSymptoms.map((symptom) {
                final isSelected = widget.model.symptoms.contains(symptom);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    title: Text(
                      symptom,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          widget.model.symptoms.add(symptom);
                        } else {
                          widget.model.symptoms.remove(symptom);
                        }
                      });
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
              Text(
                "Additional Notes",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Add any other symptoms or concerns...",
                    border: InputBorder.none, // eliminamos el borde por defecto
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onChanged: (val) => widget.model.additionalNotes = val,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <- radius aquí
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
                  onPressed:
                      widget.model.symptoms.isNotEmpty ||
                          notesController.text.isNotEmpty
                      ? widget.onNext
                      : null,
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
          ),
        ),
      ],
    );
  }
}
