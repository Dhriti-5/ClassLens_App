import 'package:flutter/material.dart';
import 'package:classlens/page_animations/slide_animation.dart';
import 'package:classlens/login/teacher_otp.dart';

class TeacherSignUpPage extends StatefulWidget {
  const TeacherSignUpPage({super.key});

  @override
  State<TeacherSignUpPage> createState() => _TeacherSignUpPageState();
}

class _TeacherSignUpPageState extends State<TeacherSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  final _teacherEmailController = TextEditingController();

  // Color constants from your design
  static const Color primaryBlue = Color(0xFF4A70E2);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF2F3F7);
  static const Color textColor = Color(0xFF333333);

  @override
  void dispose() {
    _teacherEmailController.dispose();
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
                const SizedBox(height: 8),
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
                _buildTeacherSignUpPageCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherSignUpPageCard() {
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
              'Register Here',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have a password!",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const Text(
                  "Do you want to change it?",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _teacherEmailController,
              decoration:
              _inputDecoration('University Email Address', Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an email";
                }
                final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                final bool domainRegex = RegExp(
                  r"^[a-zA-Z0-9._%+-]+@msubaroda\.ac\.in$",
                ).hasMatch(value);

                if(!emailValid){
                  return "Please enter a valid email";
                }
                if (!domainRegex) {
                  return "Please enter a valid University email";
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
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
              onPressed: () {
               if(_formKey.currentState!.validate()){
                 navigatorWithAnimation(context, TeacherOtpPage(email: _teacherEmailController.text));
               }
              },
              child: Text('Get OTP',
                  style:TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
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