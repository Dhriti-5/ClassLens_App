import 'package:classlens/login/teacher/teacher_login.dart';
import 'package:classlens/page_animations/slide_animation.dart';
import 'package:flutter/material.dart';


const Color primaryBackgroundColor = Color(0xFFF0F4F8);
const Color cardBackgroundColor = Colors.white;
const Color primaryTextColor = Color(0xFF1A2533);
const Color secondaryTextColor = Color(0xFF6C757D);
const Color iconColorStudent = Color(0xFF2563EB);
const Color iconColorTeacher = Color(0xFFF59E0B);
const Color circleColor1 = Color.fromARGB(255, 178, 218, 255);
const Color circleColor2 = Color.fromARGB(255, 201, 247, 222);

class LoginSelector extends StatelessWidget {
  const LoginSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -screenSize.width * 0.3,
            left: -screenSize.width * 0.3,
            child: CircleAvatar(
              radius: screenSize.width * 0.45,
              backgroundColor: circleColor1.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: -screenSize.width * 0.4,
            right: -screenSize.width * 0.4,
            child: CircleAvatar(
              radius: screenSize.width * 0.5,
              backgroundColor: circleColor2.withOpacity(0.5),
            ),
          ),

          // --- Main Content ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.school, size: 40, color: primaryTextColor),
                      SizedBox(width: 12),
                      FittedBox(
                        child: Text(
                          "ClassLens",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  FittedBox(
                    child: const Text(
                      "Choose Your Role",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),


                  RoleCard(
                    icon: Icons.book_outlined,
                    title: "Login as a Student",
                    description: "Access your courses, attendance, and grades",
                    iconColor: iconColorStudent,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Student login coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  RoleCard(
                    icon: Icons.person_outline,
                    title: "Login as Teacher",
                    description: "Manage classes, track attendance, and insights",
                    iconColor: iconColorTeacher,
                    onTap: () {
                      navigatorWithAnimation(context, const Login());
                    },
                  ),
                  const Spacer(flex: 3),

                  // --- Footer ---
                  FittedBox(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Need help? Contact support",
                        style: TextStyle(
                          fontSize: 15,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class RoleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });

    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final double scale = _isPressed ? 0.96 : 1.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(widget.icon, size: 40, color: widget.iconColor),
              const SizedBox(height: 16),
              FittedBox(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: secondaryTextColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}