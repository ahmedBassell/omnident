import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:omni_dent/core/models/gender.dart';
import 'package:omni_dent/core/models/tooth_state.dart';
import 'package:omni_dent/database/tables.dart';
import 'connection/connection.dart' as conn;

part 'database.g.dart';

@DriftDatabase(tables: [
  Patients,
  Locations,
  Instruments,
  Appointments,
  Sessions,
  SessionTeeth,
  SessionAttachments
])
class OmniDatabase extends _$OmniDatabase {
  OmniDatabase() : super(conn.connect());

  OmniDatabase.forTesting(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Make sure that foreign keys are enabled
        await customStatement('PRAGMA foreign_keys = ON');

        if (details.wasCreated) {
          // Create a bunch of default values so the app doesn't look too empty
          // on the first start.
          await into(patients).insert(Patient(
              id: 1,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              name: "Ahmed Bassell",
              gender: Gender.male,
              birthDate: DateTime(1993)));
        }

        if (kDebugMode) {
          // This check pulls in a fair amount of code that's not needed
          // anywhere else, so we recommend only doing it in debug builds.
          await conn.validateDatabaseSchema(this);
        }
      },
    );
  }
}
