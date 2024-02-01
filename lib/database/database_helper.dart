// database_helper.dart
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../screens/employee.dart';

class DatabaseHelper {
  static final _databaseName = "EmployeeDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'employees';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnYearsOfWork = 'yearsOfWork';
  static const columnIsActive = 'isActive';
  static const columnPosition = 'position';
  static const columnDepartment = 'department';
  static const columnSalary = 'salary';
  static const columnDateOfHire = 'dateOfHire';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnYearsOfWork INTEGER NOT NULL,
            $columnIsActive INTEGER NOT NULL,
            $columnPosition TEXT NOT NULL,
            $columnDepartment TEXT NOT NULL,
            $columnSalary REAL NOT NULL,
            $columnDateOfHire INTEGER NOT NULL
          )
          ''');
  }

  // Helper methods

  // Insert an employee into the database
  Future<int> insert(Employee employee) async {
    Database db = await instance.database;
    return await db.insert(table, employee.toMap());
  }

  // Update an employee in the database
  Future<int> update(Employee employee) async {
    Database db = await instance.database;
    return await db.update(table, employee.toMap(),
        where: '$columnId = ?', whereArgs: [employee.id]);
  }

  // Delete an employee from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Get all employees from the database
  Future<List<Employee>> getAllEmployees() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((e) => Employee.fromMap(e)).toList();
  }
}
