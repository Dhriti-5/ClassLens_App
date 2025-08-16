import 'package:flutter/material.dart';
import 'package:classlens/data_models/departments.dart';
import 'package:classlens/api/fetchDepartments.dart';
import 'package:flutter/services.dart';
import 'package:classlens/login/teacher_login.dart';
import 'package:classlens/page_animations/slide_animation.dart';

class TeacherSignUpPage extends StatefulWidget {
  const TeacherSignUpPage({super.key});

  @override
  State<TeacherSignUpPage> createState() => _TeacherSignUpPageState();
}

class _TeacherSignUpPageState extends State<TeacherSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Departments>> _departments;
  bool _isLoading = false;

  var _teacherNameController = TextEditingController();
  var _teacherEmailController = TextEditingController();
  var _teacherPasswordController = TextEditingController();

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
  void dispose(){
    _teacherNameController.dispose();
    _teacherEmailController.dispose();
    _teacherPasswordController.dispose();
    super.dispose();
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

            TextFormField(
              controller: _teacherNameController,
              decoration: _inputDecoration('Full Name', Icons.person_outline),
              validator: (value){
                if(value==null || value.isEmpty){
                 return "Please enter your name";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
                controller: _teacherEmailController,
                decoration: _inputDecoration('Email Address', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Please enter an email";
                  }
                  final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if(!emailValid){
                    return "Please enter a valid email";
                  }

                  return null;
              },
            ),

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

            TextFormField(
                controller: _teacherPasswordController,
                decoration: _inputDecoration('Password', Icons.lock_outline),
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (value){
                  if(value==null || value.isEmpty){
                    return "Enter a password";
                  }
                  if (value.length != 6) {
                    return 'Password must be exactly 6 digits long';
                  }
                  return null;
                },
            ),
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
              onPressed: _isLoading? null : () async{

                if(_formKey.currentState!.validate()) {
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    var name = _teacherNameController.text;
                    var email = _teacherEmailController.text;
                    var password = _teacherPasswordController.text;

                    if (departmentID != null || departmentID!.isEmpty) {
                      final String? responce = await ApiServices.signUpTeacher(
                          name: name,
                          email: email,
                          password: password,
                          departmentID: departmentID
                      );

                      if (!context.mounted) return;
                      print(responce);

                      if (responce == 'success') {
                        final snackBar = SnackBar(
                          content: Text('Registered successfully!'),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        navigatorWithAnimation(context, const Login());
                      }
                      else {
                        final snackBar = SnackBar(
                          content: Text('Registration failed: $responce '),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  }
                  catch(e){
                    print(e);
                  }
                  finally{
                    setState(() {
                      _isLoading=false;
                    });
                  }
                }
              },
              child: _isLoading? const CircularProgressIndicator(color: Colors.white):const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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