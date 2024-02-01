import 'package:flutter/material.dart';
import 'package:workinsight/screens/employee.dart';
import 'package:workinsight/screens/employee_list_view.dart';

import 'database/database_helper.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Employee> employees = [];

  MyApp({super.key});

  Future<void> _loadEmployees() async {
    await DatabaseHelper.instance.database;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Demo App',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _loadEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const EmployeeListView();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
