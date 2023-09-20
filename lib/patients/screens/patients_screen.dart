import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/empty_states_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/services/snack_bar_service.dart';
import 'package:omni_dent/core/widgets/patient_creation_form.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/patients/widgets/patient_item.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  SnackBarService get _snackBarService => GetIt.I<SnackBarService>();
  EmptyStatesService get _emptyStatesService => GetIt.I<EmptyStatesService>();
  List<Patient> patients = [];
  List<Patient> filteredPatients = [];
  String _emptyStateCopy = "";

  @override
  void initState() {
    filteredPatients = patients;
    _patientsService.getPatients(limit: 10, offset: 0).then((patientsRecords) {
      setState(() {
        patients = patientsRecords;
        filteredPatients = patients;
      });
    });
    _emptyStateCopy = _emptyStatesService.generatePatientsEmptyState();

    super.initState();
  }

  void _refreshPatients() {
    _patientsService.getPatients(limit: 10, offset: 0).then((patientsRecords) {
      setState(() {
        filteredPatients = patientsRecords;
      });
    });
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
            child: filteredPatients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      return PatientItem(
                        patient: filteredPatients[index],
                        onPatientDelete: deletePatient,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            _emptyStateCopy,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          )),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showPatientSheet();
            },
            child: Text('Add a Patient'),
          ),
        ],
      ),
    );
  }

  void _showPatientSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PatientCreationForm();
      },
    ).whenComplete(() {
      _refreshPatients();
    });
  }

  void deletePatient({required int patientId}) async {
    await _patientsService.delete(patientId: patientId);
    _snackBarService.show(context, "Patient deleted successfuly!");
    _refreshPatients();
  }
}
