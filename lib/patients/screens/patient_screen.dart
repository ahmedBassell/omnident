import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:omni_dent/core/models/tooth_state.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/widgets/patient_avatar.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/sessions/widgets/session_item.dart';
import 'package:omni_dent/sessions/widgets/sessions_list.dart';

class PatientScreen extends StatefulWidget {
  final Patient patient;

  PatientScreen({required this.patient});

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      SessionsTab(patient: widget.patient),
      AttachmentsTab(),
    ];

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
    String _lastVisit = DateFormat('E, MMM d y').format(DateTime(2023));
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      color: Colors.white, // Set the background color to white
      child: Column(
        children: [
          PatientAvatar(displayName: widget.patient.name, radius: 50),
          SizedBox(height: 16),
          Text(
            widget.patient.name,
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
      color: Colors.white,
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
              color: _currentIndex == index
                  ? Colors.teal.shade200
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _currentIndex == index ? Colors.teal.shade200 : Colors.black,
          ),
        ),
      ),
    );
  }
}

class SessionsTab extends StatelessWidget {
  final Patient patient;

  const SessionsTab({super.key, required this.patient});
  @override
  Widget build(BuildContext context) {
    return SessionsList(patient: patient);
  }

  void onCreateSession() {
    print("Create new session here");
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
