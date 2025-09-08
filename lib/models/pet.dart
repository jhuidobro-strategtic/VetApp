class Pet {
  final int petId;
  final String? clinicalRecordCode;
  final String? chipNumber;
  final String name;
  final String? birthDate;
  final String? weight;
  final String age;
  final String? reasonForDeactivation;
  final String? deactivationDate;
  final String? healthStatus;
  final String? status;
  final String? photoUrl;

  final String clientName;
  final String speciesName;
  final String breedName;
  final String genderName;

  Pet({
    required this.petId,
    required this.clinicalRecordCode,
    required this.chipNumber,
    required this.name,
    required this.birthDate,
    required this.weight,
    required this.age,
    this.reasonForDeactivation,
    this.deactivationDate,
    required this.healthStatus,
    required this.status,
    required this.photoUrl,
    required this.clientName,
    required this.speciesName,
    required this.breedName,
    required this.genderName,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json["PetID"],
      clinicalRecordCode: json["clinicalRecordCode"],
      chipNumber: json["chipNumber"],
      name: json["name"],
      birthDate: json["birthDate"],
      weight: json["weight"],
      age: json["age"],
      reasonForDeactivation: json["reasonForDeactivation"],
      deactivationDate: json["deactivationDate"],
      healthStatus: json["healthStatus"],
      status: json["status"],
      photoUrl: json["photo_url"],
      clientName: json["client"]["name"],
      speciesName: json["species"]["speciesName"],
      breedName: json["breed"]["breedName"],
      genderName: json["gender"]["genderName"],
    );
  }
}
