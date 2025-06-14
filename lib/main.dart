import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:workforce_iq/db/database_helper.dart';
import 'package:workforce_iq/screens/employee_screen.dart';
import 'package:workforce_iq/screens/add_employee.dart';
import 'package:workforce_iq/screens/event_screen.dart';
import 'package:workforce_iq/screens/setup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  // Set the database factory for desktop
  databaseFactory = databaseFactoryFfi;
  await windowManager.ensureInitialized();
  await windowManager.setMinimumSize(const Size(1200, 600));
  final db = DatabaseHelper.instance;
  await db.applyScheduledStatusUpdates();
  final hasSettings = await db.hasSettings();
  runApp(EmployeeApp(
    isFirstLaunch: !hasSettings,
  ));
}

class EmployeeApp extends StatelessWidget {
  final bool isFirstLaunch;

  const EmployeeApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkforceIQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: isFirstLaunch ? '/setup' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const WorkforceDashboard(),
        '/employee': (context) => const EmployeeInfoPage(),
        '/addemployee': (context) => const AddEmployeePage(),
        '/eventHistory': (context) => const EventInfoPage(),
        '/setup': (context) => const SetupScreen(),
      },
    );
  }
}
