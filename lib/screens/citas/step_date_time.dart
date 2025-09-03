import 'package:flutter/material.dart';
import 'appointment_model.dart';

class StepDateTime extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final AppointmentModel model;

  const StepDateTime({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.model,
  });

  @override
  State<StepDateTime> createState() => _StepDateTimeState();
}

class _StepDateTimeState extends State<StepDateTime> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  List<String> timeSlots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 👉 parte superior fija
        const Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Date & Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // 👉 contenido scrolleable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                      widget.model.selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  "Available Time Slots",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap:
                      true, // 👉 importante para que funcione dentro del scroll
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3.5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: timeSlots.map((time) {
                    final isSelected = selectedTime == time;
                    return OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.white,
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.deepPurpleAccent
                              : Colors.grey.shade300,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTime = time;
                          widget.model.selectedTime = time;
                        });
                      },
                      child: Text(time),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        // 👉 botones fijos abajo
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
                  onPressed: selectedTime != null ? widget.onNext : null,
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
