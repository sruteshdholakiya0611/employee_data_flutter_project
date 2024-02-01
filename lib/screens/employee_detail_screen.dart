// employee_detail_screen.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_edit_employee_screen.dart';
import 'employee.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailScreen({Key? key, required this.employee}) : super(key: key);

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedEmployee = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditEmployeeScreen(existingEmployee: widget.employee),
                ),
              );

              if (updatedEmployee != null && updatedEmployee is Employee) {
                // Update the existing employee in the list
                setState(() {
                  widget.employee.name = updatedEmployee.name;
                  widget.employee.yearsOfWork = updatedEmployee.yearsOfWork;
                  // Update other properties if needed
                });

                // Update the employee in the database
                await DatabaseHelper.instance.update(updatedEmployee);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEmployee(widget.employee),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.employee.name}'),
            Text('Years of Work: ${widget.employee.yearsOfWork}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  void _deleteEmployee(Employee employee) async {
    bool confirmDelete = await _showDeleteConfirmationDialog(employee);

    if (confirmDelete == true) {
      await DatabaseHelper.instance.delete(employee.id);

      // Remove the employee from the list
      Navigator.pop(context, true);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(Employee employee) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
