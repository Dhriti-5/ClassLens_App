import 'package:classlens/page_animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:classlens/login/teacher_signup_page.dart';
import 'package:classlens/api/login_api.dart';
import 'package:classlens/teacher_home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isChecked = false;
  bool _obscurePassword = true;


  final _teacherEmailController = TextEditingController();
  final _teacherPasswordController = TextEditingController();

  // Color constants from your design
  static const Color primaryBlue = Color(0xFF4A70E2);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF2F3F7);
  static const Color textColor = Color(0xFF333333);

  @override
  void initState(){
    super.initState();
    _teacherPasswordController.clear();
    _teacherEmailController.clear();
    //checkRememberMe();
  }
  @override
  void dispose() {
    _teacherEmailController.dispose();
    _teacherPasswordController.dispose();
    super.dispose();
  }
  
  void checkRememberMe() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //bool rememberMe = prefs.getBool("rememberMe") ?? false;
    prefs.setBool("rememberMe", false);
    bool rememberMe =false;

    navigatorWithAnimation(context, Home());
    return;
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _teacherPasswordController,
              decoration: _inputDecoration('Password', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _obscurePassword=!_obscurePassword;
                    });
                  },
                  icon: Icon(_obscurePassword?Icons.visibility_off:Icons.visibility),
                  color: Colors.black54,)
              ),
              obscureText: _obscurePassword,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter a password";
                }
                if(value.length >20){
                 return "Password is too long";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    }),
                const Text("Remember Me"),
              ],
            ),
            const SizedBox(height: 12),
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
              onPressed: _isLoading
                  ? null
                  : () async {
                if (_formKey.currentState!.validate()) {

                  print('Email: ${_teacherEmailController.text}');
                  setState(() {
                    _isLoading = true;
                  });
                  bool responce = await ApiServices.validateTeacher(email: _teacherEmailController.text, password: _teacherPasswordController.text);

                  if(responce){
                    _teacherEmailController.clear();
                    _teacherPasswordController.clear();
                    final SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setBool("rememberMe", isChecked);
                    setState(() {
                      _isLoading = false;
                    });
                    print("login");
                    navigatorWithAnimation(context, Home());
                  }
                  else{
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid Credentials'),backgroundColor: Colors.red,),

                    );
                    print("login failed");
                  }


                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login',
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have a password?",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    print("Navigating to the register page...");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeacherSignUpPage()),
                    );
                  },
                  child: Text(
                    'Register!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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