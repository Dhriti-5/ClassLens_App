import 'dart:async';

import 'package:classlens/login/teacher_login.dart';
import 'package:classlens/page_animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:classlens/api/login_api.dart';
import 'package:classlens/login/teacher_password_setter.dart';

class TeacherOtpPage extends StatefulWidget {
  final String email;
  const TeacherOtpPage({super.key, required this.email});

  @override
  State<TeacherOtpPage> createState() => _TeacherOtpPageState();
}

class _TeacherOtpPageState extends State<TeacherOtpPage> {
  // Controllers and FocusNodes for the 4 OTP boxes
  final _otpController1 = TextEditingController();
  final _otpController2 = TextEditingController();
  final _otpController3 = TextEditingController();
  final _otpController4 = TextEditingController();

  static const int initialTimerSeconds=120;
  late int secondsRemaining=initialTimerSeconds;
  Timer? timer;

  final _otpFocusNode1 = FocusNode();
  final _otpFocusNode2 = FocusNode();
  final _otpFocusNode3 = FocusNode();
  final _otpFocusNode4 = FocusNode();

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
    Future<bool>responce = ApiServices.sendOpt(email: widget.email);
    _resetAndStartTimer();
  }

  void _resetAndStartTimer() {
    timer?.cancel();
    setState(() {
      secondsRemaining=initialTimerSeconds;
    });

    timer=Timer.periodic(const Duration(seconds: 1), (timer){
      if(secondsRemaining==0){
        timer.cancel();
      }
      else{
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  String get _formattedTime{
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';

  }

  @override
  void dispose() {
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _otpFocusNode1.dispose();
    _otpFocusNode2.dispose();
    _otpFocusNode3.dispose();
    _otpFocusNode4.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> _confirmOtp() async {
    final otp = _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text;

    if (otp.length == 4) {
      print(int.parse(otp));
      bool responce = await ApiServices.verifyOpt(email: widget.email, otp : int.parse(otp));
      if(responce){
        print("OTP verified");
        Navigator.of(context)
        ..pop()
        ..pop();
        navigatorWithAnimation(context, TeacherPasswordSetter(email: widget.email));
      }
      else{
        print("OTP not verified");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 4 digits of the OTP.')),
      );
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
                  'Verification',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                    color: textColor,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 30),
                _buildOtpCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpCard() {
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
            'Enter OTP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "An OTP has been sent to\n${widget.email}",
            style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildOtpBoxes(),
          const SizedBox(height: 16),
          _buildResendOtp(),
          const SizedBox(height: 24),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: _confirmOtp,
      child: const Text('Confirm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _otpTextField(context, _otpController1, _otpFocusNode1, true),
        _otpTextField(context, _otpController2, _otpFocusNode2, false),
        _otpTextField(context, _otpController3, _otpFocusNode3, false),
        _otpTextField(context, _otpController4, _otpFocusNode4, false),
      ],
    );
  }

  Widget _buildResendOtp() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Didn't receive the OTP?  ", style: TextStyle(color: Colors.black54)),
            TextButton(
              onPressed: () async {
                _resetAndStartTimer();
                bool responce = await ApiServices.sendOpt(email: widget.email);
                if(responce){
                  ScaffoldMessenger.of(context).showSnackBar(
                      new SnackBar(
                        content: Text("OTP resent! Please check your email for the code"),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                  );
                  print('Resending OTP to ${widget.email}');
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      new SnackBar(
                        content: Text("Unexpected error occurred"),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                  );
                  print('failed in Resending OTP to ${widget.email}');

                }

              },
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Otp will expire in: ", style: TextStyle(color: Colors.black54)),
            Text(
              _formattedTime,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _otpTextField(BuildContext context, TextEditingController controller, FocusNode focusNode, bool autoFocus) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextFormField(
        autofocus: autoFocus,
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          fillColor: textFieldFillColor,
          filled: true,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: primaryBlue, width: 2.0),
          ),
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
}

