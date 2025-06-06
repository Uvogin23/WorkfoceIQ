class Event {
  int? id;
  int employeeId;
  String eventType; // e.g. "Sick Leave", "Mission", "Holiday"
  DateTime startDate;
  DateTime endDate;
  bool isActive;
  final String? employeeName;

  Event({
    this.id,
    required this.employeeId,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.employeeName,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'event_type': eventType,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'is_active': isActive ? 1 : 0,
    };
  }

  // Convert from Map to Event
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      employeeId: map['employee_id'],
      eventType: map['event_type'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      isActive: map['is_active'] == 0 ? false : true,
      employeeName: map['employee_name'], // may be null
    );
  }
}
