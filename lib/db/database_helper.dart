import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:workforce_iq/models/employee.dart';
import 'package:workforce_iq/models/event.dart';
import 'package:workforce_iq/models/notification.dart'; // Make sure sqflite_common_ffi and sqflite imported

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'employee_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  state TEXT NOT NULL,
  birthday TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  rank TEXT NOT NULL,
  card_number TEXT UNIQUE NOT NULL,
  badge_number TEXT UNIQUE NOT NULL,
  weapon_number TEXT UNIQUE NOT NULL,
  arrival_date TEXT NOT NULL,
  office TEXT NOT NULL,
  status TEXT DEFAULT 'Available',
  leave_wave INTEGER DEFAULT 1
);

    ''');

    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id INTEGER,
        event_type TEXT,
        start_date TEXT,
        end_date TEXT,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT,
        timestamp TEXT
      )
    ''');
  }

  // CRUD methods for Employee:

  Future<Employee> createEmployee(Employee employee) async {
    final db = await database;
    final id = await db.insert('employees', employee.toMap());
    return employee.copyWith(id: id);
  }

  Future<Employee?> getEmployee(int id) async {
    final db = await database;
    final maps = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Employee.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final result = await db.query('employees');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<Employee>> getAvailableEmployeesList() async {
    final db = await database;
    final result = await db.query(
      'employees',
      where: 'status = ?',
      whereArgs: ['Available'],
    );
    return result.map((map) => Employee.fromMap(map)).toList();
  }

  Future<List<Employee>> getUnavailableEmployeesList() async {
    final db = await database;
    final result = await db.query(
      'employees',
      where: 'status != ?',
      whereArgs: ['Available'],
    );
    return result.map((map) => Employee.fromMap(map)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTotalEmployees() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM employees');
    return result.first['count'] as int? ?? 0;
  }

  Future<int> getAvailableEmployees() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM employees WHERE status = 'Available'",
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<int> getEmployeesByStatus(String status) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM employees WHERE status = ?',
      [status],
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<void> updateEmployeeStatus(int employeeId, String newStatus) async {
    final db = await database;
    await db.update(
      'employees',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }

/** ######################################################################
 * #######################################################################
 * #######################################################################
 * ################### Crud methods for Event ##########################
*/

  Future<int> createEvent(Event event) async {
    final db = await database;

    // Step 1: Set all active events for this employee to inactive
    await db.update(
      'events',
      {'is_active': 0},
      where: 'employee_id = ? AND is_active = 1',
      whereArgs: [event.employeeId],
    );

    // Step 2: Insert the new event as active
    return await db.insert('events', event.toMap());
  }

  Future<List<Event>> getEventsByEmployee(int employeeId) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'employee_id = ?',
      whereArgs: [employeeId],
      orderBy: 'start_date DESC',
    );
    return maps.map((map) => Event.fromMap(map)).toList();
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    final maps = await db.query('events', orderBy: 'start_date DESC');
    return maps.map((map) => Event.fromMap(map)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;

    // Step 1: Get the employee_id from the event
    final event = await db.query(
      'events',
      columns: ['employee_id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (event.isEmpty) return 0;

    final employeeId = event.first['employee_id'];

    // Step 2: Delete the event
    final deleted = await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Step 3: Update employee status to 'Available'
    await db.update(
      'employees',
      {'status': 'Available'},
      where: 'id = ?',
      whereArgs: [employeeId],
    );

    return deleted;
  }

  Future<void> deactivateEvent(int id) async {
    final db = await database;
    await db.update(
      'events',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String?> getActiveEventEndDate(int employeeId) async {
    final db = await database;

    final result = await db.query(
      'events',
      columns: ['end_date'],
      where: 'employee_id = ? AND is_active = 1',
      whereArgs: [employeeId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['end_date'] as String;
    } else {
      return null; // No active event
    }
  }

  Future<void> terminateActiveEvent(int employeeId) async {
    final db = await database;
    final today = DateTime.now().toIso8601String().split('T').first;

    // Step 1: Get the active event
    final activeEvents = await db.query(
      'events',
      where: 'employee_id = ? AND is_active = 1',
      whereArgs: [employeeId],
      limit: 1,
    );

    if (activeEvents.isEmpty) return;

    final event = activeEvents.first;
    final eventType = event['event_type']?.toString().toLowerCase();

    // Step 2: Mark event as inactive and set end date
    await db.update(
      'events',
      {
        'is_active': 0,
        'end_date': today,
      },
      where: 'id = ?',
      whereArgs: [event['id']],
    );

    // Step 3: Update status and (optionally) arrival_date
    final updateFields = {'status': 'Available'};

    if (eventType == 'permission' ||
        eventType == 'maladie' ||
        eventType == 'congé') {
      updateFields['arrival_date'] = today;
    }

    await db.update(
      'employees',
      updateFields,
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }

  /** ######################################################################
 * #######################################################################
 * #######################################################################
 * ################### Crud methods for Logs ##########################
*/

  Future<void> createLog(String action) async {
    final db = await database;
    final timestamp = DateTime.now().toIso8601String();
    await db.insert(
      'logs',
      {
        'action': action,
        'timestamp': timestamp,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await database;
    return await db.query('logs', orderBy: 'timestamp DESC');
  }

  Future<void> deleteLog(int id) async {
    final db = await database;
    await db.delete('logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearLogs() async {
    final db = await database;
    await db.delete('logs');
  }

/** ######################################################################
 * #######################################################################
 * #######################################################################
 * ################### Crud methods for Logs ##########################
*/
  Future<List<NotificationMessage>> getNotifications() async {
    final db = await database;
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T').first;

    List<NotificationMessage> notifications = [];

    // ✅ 1. Events ending today
    final eventsEndingToday = await db.query(
      'events',
      where: 'is_active = 1 AND end_date = ?',
      whereArgs: [todayStr],
    );

    for (var event in eventsEndingToday) {
      final employeeId = event['employee_id'];
      final empData =
          await db.query('employees', where: 'id = ?', whereArgs: [employeeId]);
      if (empData.isNotEmpty) {
        final name = empData.first['name'];
        notifications.add(NotificationMessage(
          '⏰ $name doit reprendre son travail aujourd\'hui.',
        ));
      }
    }

    // ✅ 2. Eligible for permission after 45 days
    final eligibleStatuses = ['Available', 'Mission', 'Formation', 'Absent'];
    final employees = await db.query('employees');

    for (var emp in employees) {
      final arrivalDateStr = emp['arrival_date']?.toString();
      final status = emp['status']?.toString();
      final name = emp['name'];

      final arrivalDate = DateTime.tryParse(arrivalDateStr ?? '');
      if (arrivalDate != null &&
          eligibleStatuses.contains(status) &&
          DateTime.now().difference(arrivalDate).inDays == 45) {
        notifications.add(NotificationMessage(
          '📅 $name est éligible pour une permission.',
        ));
      }
    }

    // ✅ 3. Wave starts in 2 days
    final now = DateTime.now();
    final currentYear = now.year;
    final nextYear = now.year + 1;

    final waveStartDates = {
      1: DateTime(currentYear, 6, 3),
      2: DateTime(currentYear, 7, 20),
      3: DateTime(currentYear, 9, 10),
      4: DateTime(currentYear, 10, 30),
      5: DateTime(nextYear, 12, 20),
      6: DateTime(nextYear, 2, 15),
      7: DateTime(nextYear, 4, 4),
    };

    for (final entry in waveStartDates.entries) {
      final waveNumber = entry.key;
      final startDate = entry.value;
      final diff = startDate.difference(today).inDays;
      print(diff);
      if (diff == 2) {
        final waveEmployees = await db.query(
          'employees',
          where: 'leave_wave = ? AND status IN (?, ?, ?, ?)',
          whereArgs: [waveNumber, ...eligibleStatuses],
        );

        for (var emp in waveEmployees) {
          final name = emp['name'];
          notifications.add(NotificationMessage(
            '📢 $name est éligible pour un congé (vague $waveNumber) dans 3 jours.',
          ));
        }
      }
    }

    return notifications;
  }
}
