class Employee {
  int? id;
  String name;
  String state;
  DateTime birthday;
  String phoneNumber;
  String rank;
  String cardNumber;
  String badgeNumber;
  String weaponNumber;
  DateTime arrivalDate;
  String office;
  String status;
  int leaveWave;

  Employee({
    this.id,
    required this.name,
    required this.state,
    required this.birthday,
    required this.phoneNumber,
    required this.rank,
    required this.cardNumber,
    required this.badgeNumber,
    required this.weaponNumber,
    required this.arrivalDate,
    required this.office,
    this.status = 'Available',
    this.leaveWave = 1,
  });

  // Convert Employee to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'birthday': birthday.toIso8601String().split('T').first,
      'phone_number': phoneNumber,
      'rank': rank,
      'card_number': cardNumber,
      'badge_number': badgeNumber,
      'weapon_number': weaponNumber,
      'arrival_date': arrivalDate.toIso8601String().split('T').first,
      'office': office,
      'status': status,
      'leave_wave': leaveWave,
    };
  }

  // Convert Map to Employee
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      state: map['state'],
      birthday: DateTime.parse(map['birthday']),
      phoneNumber: map['phone_number'],
      rank: map['rank'],
      cardNumber: map['card_number'],
      badgeNumber: map['badge_number'],
      weaponNumber: map['weapon_number'],
      arrivalDate: DateTime.parse(map['arrival_date']),
      office: map['office'],
      status: map['status'],
      leaveWave: map['leave_wave'],
    );
  }
}

extension EmployeeCopyWith on Employee {
  Employee copyWith({
    int? id,
    String? name,
    String? state,
    DateTime? birthday,
    String? phoneNumber,
    String? rank,
    String? cardNumber,
    String? badgeNumber,
    String? weaponNumber,
    DateTime? arrivalDate,
    String? office,
    String? status,
    int? leaveWave,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      rank: rank ?? this.rank,
      cardNumber: cardNumber ?? this.cardNumber,
      badgeNumber: badgeNumber ?? this.badgeNumber,
      weaponNumber: weaponNumber ?? this.weaponNumber,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      office: office ?? this.office,
      status: status ?? this.status,
      leaveWave: leaveWave ?? this.leaveWave,
    );
  }
}
