import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/widgets/patient_avatar.dart';
import 'package:omni_dent/database/database.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;

  PatientScreen({required this.patient});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    SessionsTab(),
    AttachmentsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
      ),
      body: Column(
        children: [
          _buildPatientProfile(),
          _buildTabBar(),
          Expanded(
            child: _tabs[_currentIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientProfile() {
    int _age = _patientsService.calculateAge(widget.patient);
    DateTime _lastVisit = DateTime(2023);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          PatientAvatar(displayName: widget.patient.name, radius: 50),
          SizedBox(height: 16),
          Text(
            widget.patient
                .name, // Access patient data from the widget's parameter
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Age: ${_age} | Sex: ${widget.patient.gender.name}'),
          Text('Last Visit: ${_lastVisit}'),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(0, 'Sessions'),
          _buildTabItem(1, 'Attachments'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _currentIndex == index ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _currentIndex == index ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}

class SessionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Sessions Tab Content'),
    );
  }
}

class AttachmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Attachments Tab Content'),
    );
  }
}
