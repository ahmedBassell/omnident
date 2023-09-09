import 'package:flutter/material.dart';
import 'package:omni_dent/patients/screens/patient_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // PatientsService get _patientsService => GetIt.I<PatientsService>();
  // AppointmentsService get _appointmentsService =>
  //     GetIt.I<AppointmentsService>();
  // List<AppointmentWithPatient> upcomingAppointments = [];
  // List<Patient> recentPatients = [];

  @override
  void initState() {
    super.initState();
    // List<Patient> patients = [];
    // _patientsService.getPatients().then((patients) {
    //   setState(() {
    //     recentPatients = patients;
    //   });
    // });
    // _appointmentsService.getAppointments().then((data) {
    //   setState(() {
    //     upcomingAppointments = data;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInsights(),
              SizedBox(height: 16),
              _buildRecentPatientsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsights() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInsightCard(
              icon: Icons.people,
              label: 'Total Patients',
              value: '250', // Replace with actual patient count
              color: Colors.red.shade200),
          _buildInsightCard(
              icon: Icons.calendar_today,
              label: 'Today\'s Appointments',
              value: '15', // Replace with actual appointment count for today
              color: Colors.teal.shade200),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInsightCard(
              icon: Icons.location_on,
              label: 'Locations',
              value: '3', // Replace with actual location count
              color: Colors.teal.shade200),
          _buildInsightCard(
              icon: Icons.track_changes,
              label: 'Tracked Instruments',
              value: '50', // Replace with actual instrument count
              color: Colors.red.shade200),
        ],
      )
    ]);
  }

  Widget _buildInsightCard(
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Expanded(
        child: Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildRecentPatientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent Patients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        // Replace the following list with your actual list of recent patients
        _buildPatientListItem(
            'John Doe', '30 years', 'Male', Colors.teal.shade200),
        _buildPatientListItem(
            'Jane Smith', '25 years', 'Female', Colors.red.shade200),
        _buildPatientListItem(
            'Alice Johnson', '45 years', 'Female', Colors.teal.shade200),
        _buildPatientListItem(
            'Bob Brown', '38 years', 'Male', Colors.red.shade200),
        _buildPatientListItem(
            'Eva White', '29 years', 'Female', Colors.teal.shade200),
      ],
    );
  }

  Widget _buildPatientListItem(
      String name, String age, String gender, Color bgColor) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(name),
        subtitle: Text('$age · $gender'),
        leading: CircleAvatar(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          child: Text(name[0].toUpperCase()),
        ),
        // Add onTap functionality to navigate to patient details if needed
        onTap: () {
          // Navigate to patient details page
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => PatientScreen(patient: _patient)));
        },
      ),
    );
  }
}
