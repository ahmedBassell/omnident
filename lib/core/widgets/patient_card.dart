import 'package:flutter/material.dart';
import 'package:omni_dent/core/models/appointment.dart';
import 'package:omni_dent/core/models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;

  PatientCard(this.patient);

  @override
  Widget build(BuildContext context) {
    Appointment? lastAppointment = patient.lastAppointment();

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(right: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              patient.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (patient.age() > 0) Text('Age: ${patient.age()}'),
            if (patient.phone != null) Text('Phone: ${patient.phone}'),
            if (patient.email != null) Text('Email: ${patient.email}'),
            if (patient.gender != null) Text('Gender: ${patient.gender}'),
            if (lastAppointment != null)
              Text(
                'Last Appointment: ${lastAppointment.dateTime.day}/${lastAppointment.dateTime.month}/${lastAppointment.dateTime.year}',
              ),
          ],
        ),
      ),
    );
  }
}
