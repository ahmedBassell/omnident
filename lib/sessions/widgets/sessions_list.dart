import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/sessions/services/sessions_service.dart';
import 'package:omni_dent/sessions/widgets/session_creation_form.dart';
import 'package:omni_dent/sessions/widgets/session_item.dart';

class SessionsList extends StatefulWidget {
  final Patient patient;

  SessionsList({required this.patient});

  @override
  _SessionsListState createState() => _SessionsListState();
}

class _SessionsListState extends State<SessionsList> {
  SessionsService get _sessionsService => GetIt.I<SessionsService>();
  List<Session> sessions = [];
  List<SessionWithTeeth> sessionsWithTeeth = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final loadedSessions =
        await _sessionsService.getSessions(patientId: widget.patient.id);
    final loadedSessionsWithteeth = await _sessionsService.getSessionsWithTeeth(
        patientId: widget.patient.id);
    print(loadedSessionsWithteeth);
    setState(() {
      sessions = loadedSessions;
      sessionsWithTeeth = loadedSessionsWithteeth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: sessionsWithTeeth.length,
        itemBuilder: (context, index) {
          return SessionItem(
              sessionWithTeeth: sessionsWithTeeth[index],
              patient: widget.patient,
              onSessionDelete: _onSessionDelete);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSessionSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddSessionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SessionCreationForm(
                patient: widget.patient,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Refresh sessions when the bottom sheet is closed (e.g., after adding a session).
      _loadSessions();
    });
  }

  void _onSessionDelete({required int sessionId}) async {
    await _sessionsService.delete(sessionId: sessionId);
    _loadSessions();
  }
}
