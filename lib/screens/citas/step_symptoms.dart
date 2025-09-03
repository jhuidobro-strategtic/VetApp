import 'package:flutter/material.dart';
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
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Symptoms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    title: Text(symptom),
                    activeColor: Colors.deepPurpleAccent,
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
              const Text(
                "Additional Notes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Add any other symptoms or concerns...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (val) => widget.model.additionalNotes = val,
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
                  child: const Text("< BACK"),
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
          ),
        ),
      ],
    );
  }
}
