// employee_search_delegate.dart
import 'package:flutter/material.dart';
import '../screens/employee.dart';

class EmployeeSearchDelegate extends SearchDelegate<String> {
  final List<Employee> employees;

  EmployeeSearchDelegate({required this.employees});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Implement search results if needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Employee> suggestionList = employees
        .where((employee) => employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        Employee suggestion = suggestionList[index];
        return ListTile(
          title: Text(suggestion.name),
          onTap: () {
            close(context, suggestion.name);
          },
        );
      },
    );
  }
}
