class AppointmentModel {
  String? petName;
  String? petType;
  int? petAge;
  String? gender;

  List<String> symptoms = [];
  String? additionalNotes;

  DateTime? selectedDate;
  String? selectedTime;

  AppointmentModel();
}
