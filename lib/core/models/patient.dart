// import 'package:omni_dent/core/models/appointment.dart';
// import 'package:omni_dent/core/services/appointments_service.dart';

// class Patient {
//   final int id;
//   final String name;
//   final DateTime? birthdate;
//   final String? phone;
//   final String? email;
//   final String? gender;
//   final String? jobTitle;
//   final String? company;
//   final String? notes;

//   Patient(
//       {required this.id,
//       required this.name,
//       this.birthdate,
//       this.phone,
//       this.email,
//       this.gender,
//       this.jobTitle,
//       this.company,
//       this.notes});

//   int age() {
//     if (birthdate == null) {
//       return 0;
//     }
//     final currentDate = DateTime.now();
//     int age = currentDate.year - birthdate!.year;

//     if (currentDate.month < birthdate!.month ||
//         (currentDate.month == birthdate!.month &&
//             currentDate.day < birthdate!.day)) {
//       age--;
//     }

//     return age;
//   }

//   Appointment? lastAppointment() {
//     AppointmentsService _appointmentService = AppointmentsService();
//     List<Appointment> appointments =
//         _appointmentService.getPatientAppointments(this.id);
//     if (appointments.isEmpty) {
//       return null;
//     }

//     appointments.sort((a, b) =>
//         b.dateTime.compareTo(a.dateTime)); // Sort appointments by date

//     return appointments.first; // Return the most recent appointment
//   }
// }
