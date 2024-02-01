import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/employee_search_delegate.dart';
import 'add_edit_employee_screen.dart';
import 'employee.dart';
import 'employee_detail_screen.dart';

class EmployeeListView extends StatefulWidget {
  const EmployeeListView({Key? key}) : super(key: key);

  @override
  _EmployeeListViewState createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  List<Employee> filteredEmployees = [];
  String _sortField = 'name';

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _search(String query) {
    setState(() {
      filteredEmployees = filteredEmployees
          .where((employee) =>
              employee.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _sort(String field) {
    setState(() {
      _sortField = field;
      filteredEmployees.sort((a, b) {
        switch (field) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'yearsOfWork':
            return a.yearsOfWork.compareTo(b.yearsOfWork);
          case 'isActive':
            return (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0);
          default:
            return 0;
        }
      });
    });
  }
  // Delete conformation dialog

  void _showDeleteConfirmationDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel  '),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  employee.isActive = !employee.isActive;
                  // update database
                  DatabaseHelper.instance.update(employee);
                });
                Navigator.pop(context);
              },
              child: Text(employee.isActive ? 'Deactivate' : 'Activate')),
          TextButton(
            onPressed: () {
              _deleteEmployee(employee);
              Navigator.pop(context);
            },
            child: const Text('Delete  '),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(Employee employee) async {
    await DatabaseHelper.instance.delete(employee.id);
    setState(() {
      filteredEmployees.remove(employee);
    });
  }

  void _loadEmployees() async {
    List<Employee> employees = await DatabaseHelper.instance.getAllEmployees();
    setState(() {
      filteredEmployees = employees;
    });
  }

  void _navigateToAddEditEmployeeScreen(Employee? existingEmployee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditEmployeeScreen(existingEmployee: existingEmployee),
      ),
    );

    if (result != null && result is Employee) {
      setState(() {
        _loadEmployees();
        _sort(_sortField);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existingEmployee == null
              ? 'Employee added successfully'
              : 'Employee updated successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? query = await showSearch<String>(
                context: context,
                delegate: EmployeeSearchDelegate(employees: filteredEmployees),
              );
              if (query != null) {
                _search(query);
              }
            },
          ),
          PopupMenuButton(
            onSelected: _sort,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem(
                value: 'yearsOfWork',
                child: Text('Sort by Years of Work'),
              ),
              const PopupMenuItem(
                value: 'isActive',
                child: Text('Sort by Active Status'),
              ),
            ],
          ),
        ],
      ),
      body: _buildEmployeeListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddEditEmployeeScreen(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmployeeListView() {
    return ListView.builder(
      itemCount: filteredEmployees.length,
      itemBuilder: (context, index) {
        Employee employee = filteredEmployees[index];
        return _buildEmployeeListTile(employee);
      },
    );
  }

  Widget _buildEmployeeListTile(Employee employee) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          employee.name[0],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(employee.name),
      subtitle: Text('Years of Work: ${employee.yearsOfWork}'),
      trailing: employee.isActive && employee.yearsOfWork > 5 ? const Icon(Icons.flag, color: Colors.green) : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetailScreen(employee: employee),
          ),
        ).then((_) {
          setState(() {
            _sort(_sortField);
            _loadEmployees();
          });
        });
      },
      onLongPress: () {
        _showDeleteConfirmationDialog(employee);
      },
    );
  }
}
