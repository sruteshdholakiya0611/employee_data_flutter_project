import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'employee.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? existingEmployee;

  const AddEditEmployeeScreen({Key? key, this.existingEmployee}) : super(key: key);

  @override
  AddEditEmployeeScreenState createState() => AddEditEmployeeScreenState();
}

class AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _yearsOfWorkController;
  late TextEditingController _positionController;
  late TextEditingController _departmentController;
  late TextEditingController _salaryController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.existingEmployee?.name ?? '');
    _yearsOfWorkController = TextEditingController(
        text: widget.existingEmployee?.yearsOfWork.toString() ?? '');
    _positionController = TextEditingController(text: widget.existingEmployee?.position ?? '');
    _departmentController = TextEditingController(text: widget.existingEmployee?.department ?? '');
    _salaryController = TextEditingController(
        text: widget.existingEmployee?.salary.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEmployee == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearsOfWorkController,
                decoration: const InputDecoration(labelText: 'Years of Work'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the years of work';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Position'),
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveEmployee();
                },
                child: Text(widget.existingEmployee == null ? 'Add Employee' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      Employee newEmployee = _createEmployeeFromForm();

      if (widget.existingEmployee == null) {
        // Add new employee
        _saveEmployeeToDatabase(newEmployee);
      } else {
        // Edit existing employee
        _updateEmployeeInDatabase(newEmployee);
      }

      Navigator.pop(context, newEmployee); // Return the result to the calling screen
    }
  }

  void _saveEmployeeToDatabase(Employee employee) async {
    try {
      await DatabaseHelper.instance.insert(employee);
    } catch (e) {
      print('Error saving employee to the database: $e');
    }
  }

  void _updateEmployeeInDatabase(Employee employee) async {
    try {
      await DatabaseHelper.instance.update(employee);
    } catch (e) {
      print('Error updating employee in the database: $e');
    }
  }

  Employee _createEmployeeFromForm() {
    String name = _nameController.text;
    int yearsOfWork = int.tryParse(_yearsOfWorkController.text) ?? 0;
    String position = _positionController.text;
    String department = _departmentController.text;
    double salary = double.tryParse(_salaryController.text) ?? 0.0;

    // Set the id to the existing employee's id if it exists, otherwise use a new id
    int id = widget.existingEmployee?.id ?? DateTime.now().millisecondsSinceEpoch;

    return Employee(
      id: id,
      name: name,
      yearsOfWork: yearsOfWork,
      isActive: true,
      position: position,
      department: department,
      salary: salary,
      dateOfHire: DateTime.now(),
    );
  }
}
