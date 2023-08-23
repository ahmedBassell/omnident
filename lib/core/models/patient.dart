class Patient {
  final int id;
  final String name;
  final DateTime? birthdate;
  final String? phone;
  final String? email;
  final String? gender;
  final String? jobTitle;
  final String? company;
  final String? notes;

  Patient(
      {required this.id,
      required this.name,
      this.birthdate,
      this.phone,
      this.email,
      this.gender,
      this.jobTitle,
      this.company,
      this.notes});
}
