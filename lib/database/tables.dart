import 'package:drift/drift.dart';
import 'package:omni_dent/core/models/gender.dart';
import 'package:omni_dent/core/models/tooth_name.dart';
import 'package:omni_dent/core/models/tooth_state.dart';

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}

mixin TimeStamps on Table {
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

mixin SoftDeleteColumn on Table {
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Patients extends Table
    with AutoIncrementingPrimaryKey, TimeStamps, SoftDeleteColumn {
  TextColumn get name => text().withLength(min: 2, max: 32)();
  TextColumn get gender => textEnum<Gender>()();
  DateTimeColumn get birthDate => dateTime()
      .check(birthDate.isBiggerThan(Constant(DateTime(1930))))
      .withDefault(Constant(DateTime(1970)))();
  TextColumn get phone => text().withLength(min: 11, max: 14).nullable()();
  TextColumn get email => text().nullable()();
}

class Locations extends Table
    with AutoIncrementingPrimaryKey, TimeStamps, SoftDeleteColumn {
  TextColumn get name => text().withLength(min: 2, max: 32)();
  RealColumn get long => real().nullable()();
  RealColumn get lat => real().nullable()();
  IntColumn get order => integer().withDefault(const Constant(0))();
}

class Instruments extends Table with AutoIncrementingPrimaryKey, TimeStamps {
  IntColumn get location => integer().references(Locations, #id)();
  TextColumn get name => text().withLength(min: 2, max: 32)();
  TextColumn get lentToFriendName =>
      text().withLength(min: 2, max: 32).nullable()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Appointments extends Table with AutoIncrementingPrimaryKey, TimeStamps {
  IntColumn get patient => integer().references(Patients, #id)();
  IntColumn get location => integer().references(Locations, #id).nullable()();
  TextColumn get title => text().withLength(min: 2, max: 32)();
  DateTimeColumn get dateTimeFrom => dateTime()
      .check(dateTimeFrom.isBiggerThan(currentDateAndTime))
      .withDefault(currentDateAndTime)();
}

class Sessions extends Table with AutoIncrementingPrimaryKey, TimeStamps {
  IntColumn get patient => integer().references(Patients, #id)();
  TextColumn get title => text().withLength(min: 2, max: 32)();
  DateTimeColumn get dateTimeFrom =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get treatment => text().withLength(min: 0, max: 512)();
  TextColumn get symptoms => text().withLength(min: 0, max: 512).nullable()();
}

@DataClassName("SessionTooth")
class SessionTeeth extends Table with AutoIncrementingPrimaryKey, TimeStamps {
  IntColumn get patient => integer().references(Patients, #id)();
  IntColumn get session => integer().references(Sessions, #id)();
  TextColumn get state => textEnum<ToothState>()();
  TextColumn get toothName => textEnum<ToothName>()();
}

class SessionAttachments extends Table
    with AutoIncrementingPrimaryKey, TimeStamps {
  IntColumn get patient => integer().references(Patients, #id)();
  IntColumn get session => integer().references(Sessions, #id)();
  TextColumn get path => text()();
}
