import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/services/snack_bar_service.dart';
import 'package:omni_dent/core/services/utils_service.dart';
import 'package:omni_dent/core/widgets/splash_screen_wrapper.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/instruments/services/instruments_service.dart';
import 'package:omni_dent/locations/services/locations_service.dart';
import 'package:omni_dent/sessions/services/sessions_service.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => PatientsService());
  GetIt.I.registerLazySingleton(() => AppointmentsService());
  GetIt.I.registerLazySingleton(() => InstrumentsService());
  GetIt.I.registerLazySingleton(() => LocationsService());
  GetIt.I.registerLazySingleton(() => SessionsService());
  GetIt.I.registerLazySingleton(() => UtilsService());
  GetIt.I.registerLazySingleton(() => SnackBarService());
  // DB
  final database = OmniDatabase();
  GetIt.I.registerLazySingleton(() => database);
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.teal.shade200,
            secondary: Colors.red.shade200,
            background: Colors.white,
            brightness: Brightness.light),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenWrapper(),
    );
  }
}
