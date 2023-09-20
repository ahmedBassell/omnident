import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/empty_states_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/services/utils_service.dart';
import 'package:omni_dent/core/widgets/appointment_creation_form.dart';
import 'package:omni_dent/core/widgets/empty_insight_card.dart';
import 'package:omni_dent/core/widgets/patient_creation_form.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/instruments/services/instruments_service.dart';
import 'package:omni_dent/instruments/widgets/instrument_creation_form.dart';
import 'package:omni_dent/locations/services/locations_service.dart';
import 'package:omni_dent/locations/widgets/location_creation_form.dart';
import 'package:omni_dent/patients/screens/patient_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  InstrumentsService get _instrumentsService => GetIt.I<InstrumentsService>();
  LocationsService get _locationsService => GetIt.I<LocationsService>();
  AppointmentsService get _appointmentsService =>
      GetIt.I<AppointmentsService>();
  UtilsService get _utilsService => GetIt.I<UtilsService>();
  EmptyStatesService get _emptyStatesService => GetIt.I<EmptyStatesService>();

  List<Patient> recentPatients = [];
  late StreamSubscription<List<Patient>> _recentPatientsSubscription;
  String totalPatientsCount = "0";
  String totalLocationsCount = "0";
  String trackedInstrumentssCount = "0";
  String todayAppointmentsCount = "0";
  String _emptyStateCopy = "";

  @override
  void initState() {
    super.initState();

    _recentPatientsSubscription =
        _patientsService.watchRecentPatients().listen((data) {
      setState(() {
        recentPatients = data;
      });
    });

    _refreshPatientsCount();

    _refreshInstrumentsCount();

    _refreshLocationsCount();

    _refreshAppointmentsCount();

    _emptyStateCopy = _emptyStatesService.generatePatientsEmptyState();
  }

  @override
  void dispose() {
    _recentPatientsSubscription.cancel();
    super.dispose();
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
            value: totalPatientsCount, // Replace with actual patient count
            color: Colors.red.shade200,
            emptyStateMessage: "Add a Patient",
            onCardTap: () {
              _showPatientSheet();
            },
          ),
          _buildInsightCard(
              icon: Icons.calendar_today,
              label: 'Today\'s Appointments',
              value:
                  todayAppointmentsCount, // Replace with actual appointment count for today
              color: Colors.teal.shade200,
              emptyStateMessage: "Add an Appointment",
              onCardTap: () {
                _openAppointmentForm();
              }),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInsightCard(
              icon: Icons.location_on,
              label: 'Locations',
              value: totalLocationsCount,
              color: Colors.teal.shade200,
              emptyStateMessage: "Add a Location",
              onCardTap: () {
                _openLocationForm();
              }),
          _buildInsightCard(
              icon: Icons.track_changes,
              label: 'Tracked Instruments',
              value:
                  trackedInstrumentssCount, // Replace with actual instrument count
              color: Colors.red.shade200,
              emptyStateMessage: "Track Instrument",
              onCardTap: (() {
                _showAddInstrumentSheet();
              })),
        ],
      )
    ]);
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    String emptyStateMessage = 'Add', // Message for the empty state
    VoidCallback? onCardTap, // Callback for when the card is tapped
  }) {
    if (value == '0' && onCardTap != null) {
      return EmptyInsightCard(
        icon: icon,
        color: color,
        label: label,
        emptyMessage: emptyStateMessage,
        onCardTap: () {
          onCardTap();
        },
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap:
            onCardTap, // Trigger the card tap callback when the card is tapped
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Icon(
                      icon,
                      size: 32,
                      color: color,
                    ),
                    SizedBox(height: 8),
                    Text(
                      label,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentPatientsList() {
    if (recentPatients.isEmpty) {
      // Handle the case when there are no recent patients
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Text(
            _emptyStateCopy,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showPatientSheet();
            },
            child: Text('Add a Patient'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent Patients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        for (int i = 0; i < recentPatients.length; i++)
          _buildPatientListItem(
            recentPatients[i],
            recentPatients[i].name,
            _patientsService.calculateAge(recentPatients[i]).toString(),
            _utilsService.capitalize(recentPatients[i].gender.name),
            i % 2 == 0 ? Colors.teal.shade200 : Colors.red.shade200,
          ),
      ],
    );
  }

  Widget _buildPatientListItem(
      Patient _patient, String name, String age, String gender, Color bgColor) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(name),
        subtitle: Text('$age years · $gender'),
        leading: CircleAvatar(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          child: Text(name[0].toUpperCase()),
        ),
        // Add onTap functionality to navigate to patient details if needed
        onTap: () {
          // Navigate to patient details page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PatientScreen(patient: _patient)));
        },
      ),
    );
  }

  Future<void> _openLocationForm() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                8.0, 8.0, 8.0, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[LocationCreationForm()]));
      },
    ).whenComplete(() {
      _refreshLocationsCount();
    });
  }

  Future<void> _openAppointmentForm() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                8.0, 8.0, 8.0, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[AppointmentCreationForm()]));
      },
    ).whenComplete(() {
      _refreshAppointmentsCount();
    });
  }

  void _showAddInstrumentSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              InstrumentCreationForm(
                onInstrumentCreated: (newInstrument) {
                  Navigator.pop(context);
                },
              )
            ]));
      },
    ).whenComplete(() {
      _refreshInstrumentsCount();
    });
  }

  void _showPatientSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PatientCreationForm();
      },
    ).whenComplete(() {
      _refreshPatientsCount();
    });
  }

  void _refreshPatientsCount() {
    _patientsService.totalCount().then(((value) {
      setState(() {
        totalPatientsCount = value.toString();
      });
    }));
  }

  void _refreshInstrumentsCount() {
    _instrumentsService.totalCount().then(((value) {
      setState(() {
        trackedInstrumentssCount = value.toString();
      });
    }));
  }

  void _refreshLocationsCount() {
    _locationsService.totalCount().then(((value) {
      setState(() {
        totalLocationsCount = value.toString();
      });
    }));
  }

  void _refreshAppointmentsCount() {
    _appointmentsService.todayCount().then(((value) {
      setState(() {
        todayAppointmentsCount = value.toString();
      });
    }));
  }
}
