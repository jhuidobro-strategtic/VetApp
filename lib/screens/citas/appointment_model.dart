class AppointmentModel {
  String? petName;
  String? petType;
  String? petAge;
  String? gender;

  List<String> symptoms = [];
  String? additionalNotes;

  DateTime? selectedDate;
  String? selectedTime;

  AppointmentModel();
}
