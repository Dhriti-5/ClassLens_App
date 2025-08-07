import 'package:flutter/material.dart';
import 'get_departments.dart';
import 'data_models/departments.dart';

class SnackBarExample extends StatelessWidget {
  const SnackBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar Example'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show SnackBar'),
          onPressed: () {
            // 1. Create the SnackBar
            final snackBar = SnackBar(
              // 2. The content of the SnackBar
              content: const Text('This is a SnackBar!'),
              // 3. (Optional) Add an action button
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );

            // 4. Find the ScaffoldMessenger and show the SnackBar
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}

class LoginSelector extends StatefulWidget {
  const LoginSelector({super.key});

  @override
  State<LoginSelector> createState() => _LoginSelectorState();
}

class _LoginSelectorState extends State<LoginSelector> {
  late Future<List<Departments>> futureDepartments;

  @override
  void initState() {
    super.initState();
    futureDepartments = ApiServices.getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Departments"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Departments>>(
        future: futureDepartments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final departments = snapshot.data!;
            return ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {

                final department = departments[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(department.id.toString()),
                  ),
                  title: Text(department.departmentName),
                );
              },
            );
          }

          else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

