class Log {
  int? id;
  String action;
  DateTime timestamp;

  Log({
    this.id,
    required this.action,
    required this.timestamp,
  });

  // Convert to map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert from map to Log object
  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
      id: map['id'],
      action: map['action'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
