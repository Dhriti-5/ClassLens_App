import 'package:flutter/material.dart';
import 'package:classlens/data_models/departments.dart';
import 'package:classlens/api/fetchDepartments.dart';

class TeacherSignUpPage extends StatefulWidget {
  const TeacherSignUpPage({super.key});

  @override
  State<TeacherSignUpPage> createState() => _TeacherSignUpPageState();
}

class _TeacherSignUpPageState extends State<TeacherSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Departments>> _departments;

  static const Color primaryBlue = Color(0xFF4A70E2);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF2F3F7);
  static const Color textColor = Color(0xFF333333);

  String? departmentID ;
  @override
  void initState() {
    super.initState();
    _departments = ApiServices.getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Icon(Icons.school, color: primaryBlue, size: 60),

                const Text(
                  'ClassLens',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                    color: textColor,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 30),

                // 2. Main Login Card
                _buildLoginCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

            const Icon(Icons.person, color: accentYellow, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Welcome, Teacher',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: textColor,
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(decoration: _inputDecoration('Full Name', Icons.person_outline)),
            const SizedBox(height: 20),
            TextFormField(decoration: _inputDecoration('Email Address', Icons.email_outlined), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            // display department from api call

            FutureBuilder<List<Departments>>(
                future: _departments,
                builder:(context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }

                  if(snapshot.hasError){
                    return Text("Error: ${snapshot.error}");
                  }

                  if(snapshot.hasData){
                    final departments = snapshot.data;

                    return DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Departments", Icons.business_center_outlined),
                      value: departmentID,

                      isExpanded: true,
                      selectedItemBuilder: (BuildContext context) {
                        return departments!.map<Widget>((dept) {

                          return Text(
                            dept.departmentName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        }).toList();
                      },

                      items: departments?.map((dept) {

                        return DropdownMenuItem<String>(
                          value: dept.id.toString(),
                          child: Tooltip(
                            message: dept.departmentName,
                            child: Text(
                              dept.departmentName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          departmentID = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please Select a department' : null,
                    );
                  }

                  return TextFormField(
                    decoration: _inputDecoration("Departments", Icons.business_center_outlined)
                        .copyWith(hintText: 'No departments available', fillColor: Colors.grey.shade200),
                    enabled: false,

                  );
                },
            ),

            const SizedBox(height: 20),
            TextFormField(decoration: _inputDecoration('Password', Icons.lock_outline), obscureText: true),
            const SizedBox(height: 32),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                shadowColor: primaryBlue.withOpacity(0.4),
              ),
              onPressed: () {},
              child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // A helper method for consistent input field styling
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54,fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.black54,size: 23,),
      fillColor: textFieldFillColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryBlue, width: 2.0),
      ),
    );
  }
}