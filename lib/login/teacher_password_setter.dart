import 'package:classlens/login/teacher_login.dart';
import 'package:classlens/page_animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:classlens/api/login_api.dart';

class TeacherPasswordSetter extends StatefulWidget {
  final String email;
  const TeacherPasswordSetter({super.key, required this.email});

  @override
  State<TeacherPasswordSetter> createState() => _TeacherPasswordSetterState();
}

class _TeacherPasswordSetterState extends State<TeacherPasswordSetter> {
  final _formKey = GlobalKey<FormState>();

  final _teacherPasswordController = TextEditingController();
  final _teacherConfirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Color constants for styling
  static const Color primaryBlue = Color(0xFF4A70E2);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF2F3F7);
  static const Color textColor = Color(0xFF333333);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _teacherPasswordController.dispose();
    _teacherConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _confirmPassword() async {
      if(_formKey.currentState!.validate()){
        if(_teacherPasswordController.text != _teacherConfirmPasswordController.text){
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Passwords do not match"),backgroundColor: Colors.red,));
          return;
        }
        bool responce = await ApiServices.setPassword(email: widget.email, password: _teacherPasswordController.text);

        if(responce){
          print("password set");
          Navigator.pop(context);
          navigatorWithAnimation(context, Login());
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("password Set")));
          return;
        }



      }
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
                const Icon(Icons.dangerous, color: primaryBlue, size: 60),
                const SizedBox(height: 8),
                const Text(
                  'Password Set',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                    color: textColor,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 30),
                _buildPasswordCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCard() {
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
      child: Column(
        children: [
          const Icon(Icons.password, color: accentYellow, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Enter New Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "New password for ${widget.email}",
            style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildPassword(),
          const SizedBox(height: 24),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: _confirmPassword,
      child: const Text('Confirm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPassword() {
    return Container(
      padding: const EdgeInsets.all(24.0),

      child: Form(
        key: _formKey,
        child: Column(
          children:[
            TextFormField(
              controller: _teacherPasswordController,
              decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _obscurePassword=!_obscurePassword;
                    });
                  },
                  icon: Icon(_obscurePassword?Icons.visibility_off:Icons.visibility),
                  color: Colors.black54,
                )),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Enter a password";
                }
                if(value.length >20){
                  return "Password is too long";
                }
                return null;
              },
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _teacherConfirmPasswordController,
              decoration: _inputDecoration("Confirm Password", Icons.lock_outline).copyWith(suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    _obscureConfirmPassword=!_obscureConfirmPassword;
                  });
                },
                icon: Icon(_obscureConfirmPassword?Icons.visibility_off:Icons.visibility),
                color: Colors.black54,
              )),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Enter a password";
                }
                if(value.length >20){
                  return "Password is too long";
                }
                return null;
              },
              obscureText: _obscureConfirmPassword,
            ),

          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      shadowColor: primaryBlue.withOpacity(0.4),
    );
  }
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54, fontSize: 15),
      prefixIcon: Icon(icon, color: Colors.black54, size: 23),
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

