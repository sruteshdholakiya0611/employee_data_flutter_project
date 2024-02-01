/// Represents an Employee in the system.
class Employee {
  int id;
  String name;
  int yearsOfWork;
  bool isActive;
  String position;
  String department;
  double salary;
  DateTime dateOfHire;

  /// Creates an instance of an Employee.
  ///
  /// Takes in [id], [name], [yearsOfWork], [isActive], [position], [department], [salary], and [dateOfHire] as parameters.
  Employee({
    required this.id,
    required this.name,
    required this.yearsOfWork,
    required this.isActive,
    required this.position,
    required this.department,
    required this.salary,
    required this.dateOfHire,
  });

  /// Converts the Employee instance to a Map.
  ///
  /// This is useful for database operations, for example.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'yearsOfWork': yearsOfWork,
      'isActive': isActive ? 1 : 0,
      'position': position,
      'department': department,
      'salary': salary,
      'dateOfHire': dateOfHire.millisecondsSinceEpoch,
    };
  }

  /// Creates an Employee instance from a Map.
  ///
  /// This is useful when retrieving data from a database, for example.
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      yearsOfWork: map['yearsOfWork'],
      isActive: map['isActive'] == 1,
      position: map['position'],
      department: map['department'],
      salary: map['salary'],
      dateOfHire: DateTime.fromMillisecondsSinceEpoch(map['dateOfHire']),
    );
  }
}