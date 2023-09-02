import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/database/database.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  List<Patient> patients = [];

  List<Patient> filteredPatients = [];

  @override
  void initState() {
    filteredPatients = patients;
    _patientsService.getPatients(limit: 10, offset: 0).then((patientsRecords) {
      setState(() {
        patients = patientsRecords;
        filteredPatients = patients;
      });
    });
    super.initState();
  }

  void _filterPatients(String query) {
    setState(() {
      filteredPatients = patients.where((patient) {
        final lowerCaseQuery = query.toLowerCase();
        final String name = patient.name.toLowerCase();
        final String phone = patient.phone ?? "";
        return name.contains(lowerCaseQuery) || phone.contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterPatients,
              decoration: InputDecoration(
                labelText: 'Search by name or phone',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                return PatientItem(patient: filteredPatients[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PatientItem extends StatelessWidget {
  final Patient patient;

  PatientItem({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(patient.name),
      subtitle: Text(patient.phone ?? "+2***********"),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'update',
            child: Text('Update'),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (value) {
          if (value == 'update') {
            // Handle update action
          } else if (value == 'delete') {
            // Handle delete action
          }
        },
      ),
    );
  }
}
