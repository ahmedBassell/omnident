import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Appointment> upcomingAppointments = [
    Appointment(
      patientName: 'John Smith',
      appointmentLabel: 'Dental Checkup',
      dateTime: DateTime(2023, 6, 1, 10, 0), // Example date and time
    ),
    Appointment(
      patientName: 'Jane Doe',
      appointmentLabel: 'Orthodontic Consultation',
      dateTime: DateTime(2023, 6, 2, 15, 30), // Example date and time
    ),
    Appointment(
      patientName: 'Michael Johnson',
      appointmentLabel: 'Cleaning',
      dateTime: DateTime(2023, 6, 3, 11, 45), // Example date and time
    ),
  ];

  List<Patient> recentPatients = [
    Patient(
      name: 'John Smith',
      gender: 'Male',
      age: 35,
      phoneNumber: '123-456-7890',
      lastAppointment: DateTime(2023, 5, 20),
    ),
    Patient(
      name: 'Jane Doe',
      gender: 'Female',
      age: 28,
      phoneNumber: '987-654-3210',
      lastAppointment: DateTime(2023, 5, 15),
    ),
    Patient(
      name: 'Michael Johnson',
      gender: 'Male',
      age: 42,
      phoneNumber: '555-123-4567',
      lastAppointment: DateTime(2023, 5, 10),
    ),
    // ... Add more recent patients
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Display a list of upcoming appointments with details
            for (var appointment in upcomingAppointments)
              _buildAppointmentCard(appointment),
            SizedBox(height: 16),
            Text(
              'Most Recent Patients',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildRecentPatientsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOptions(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
          // Add more navigation tabs here as needed
        ],
        onTap: (index) {
          // Handle navigation
          // ...
        },
      ),
    );
  }

  Widget _buildRecentPatientsSection() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentPatients.length,
        itemBuilder: (context, index) {
          var patient = recentPatients[index];
          return _buildPatientCard(patient);
        },
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(right: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(patient.name, style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Gender: ${patient.gender}, Age: ${patient.age}'),
            Text('Phone: ${patient.phoneNumber}'),
            Text(
                'Last Appointment: ${patient.lastAppointment.day}/${patient.lastAppointment.month}/${patient.lastAppointment.year}'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(appointment.patientName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.appointmentLabel),
            Text(
              'Date: ${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}',
            ),
            Text(
              'Time: ${appointment.dateTime.hour}:${appointment.dateTime.minute}',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  // Handle creating a new patient
                  // Close the bottom sheet after action
                  Navigator.pop(context);
                },
                title: Text('Create New Patient'),
                leading: Icon(Icons.person_add),
              ),
              SizedBox(height: 16),
              ListTile(
                onTap: () {
                  // Handle creating a new appointment
                  // Close the bottom sheet after action
                  Navigator.pop(context);
                },
                title: Text('Create New Appointment'),
                leading: Icon(Icons.calendar_today),
              ),
            ],
          ),
        );
      },
    );
  }
}
