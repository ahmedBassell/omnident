import 'package:flutter/material.dart';
import 'package:omni_dent/appointments/screens/appointments_screen.dart';
import 'package:omni_dent/core/screens/dashboard_screen.dart';
import 'package:omni_dent/core/widgets/appointment_creation_form.dart';
import 'package:omni_dent/core/widgets/patient_creation_form.dart';
import 'package:omni_dent/instruments/screens/instruments_screen.dart';
import 'package:omni_dent/locations/widgets/location_creation_form.dart';
import 'package:omni_dent/patients/screens/patients_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    DashboardScreen(),
    PatientsScreen(),
    Container(),
    AppointmentsScreen(),
    InstrumentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // selectedItemColor: Colors.blue,
        // backgroundColor: Colors.white,
        // unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 22,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                size: 32,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handyman), label: 'Instruments'),
          // Add more navigation tabs here as needed
        ],
        onTap: (index) => {
          if (index == 2)
            {_showAddOptions(context)}
          else
            {
              setState(() {
                _currentIndex = index;
              })
            }
        },
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
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return PatientCreationForm();
                    },
                  ).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                title: Text('Create New Patient'),
                leading: Icon(Icons.person_add),
              ),
              SizedBox(height: 16),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AppointmentCreationForm();
                    },
                  ).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                title: Text('Create New Appointment'),
                leading: Icon(Icons.calendar_today),
              ),
              SizedBox(height: 16),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[LocationCreationForm()]));
                    },
                  ).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                title: Text('Create New Location'),
                leading: Icon(Icons.pin_drop),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => {
          // Navigator.pop(context);
          setState(() {
            // recentPatients = _patientsService.getPatients();
            // upcomingAppointments = _appointmentsService.getAppointments();
          })
        });
  }
}
