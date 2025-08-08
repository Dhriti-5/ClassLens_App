import 'package:classlens/page_animations/slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:classlens/login/teacher_signup_page.dart';

class LoginSelector extends StatefulWidget{
  const LoginSelector({super.key});

  @override
  State<LoginSelector> createState() => _LoginSelectorState();
}

class _LoginSelectorState extends State<LoginSelector> {
  @override
  Widget build(BuildContext context) {

  return Scaffold(
    backgroundColor: const Color(0xFFF9FAFB),

    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          //Top section
          Padding(
            padding: const EdgeInsets.only(left: 10.0,bottom: 0.0,top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 22,),

                //logo placement
                Icon(Icons.school,size: 60, color: const Color(0xFF2563EB)),
                const SizedBox(width: 15,),

                //APP NAME on TOP
                Text(
                  "ClassLens",
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827)
                  ),
                ),
              ],
            ),
          ),

          //middle section
          Column(
            children: [
              RoleCard(
                  icon: Icons.class_,
                  title: "Login as a Student",
                  description:  "Access your courses, attendance, and grades",
                  color: const Color(0xFF2563EB),
                  onTap: (){
                    // navigation to student login

                    // final snackBar = SnackBar(
                    //   content: const Text('Student login clicked'),
                    //   action: SnackBarAction(label: 'undo', onPressed: (){
                    //
                    //   }),
                    // );
                    //
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);


                  }
              ),
              // const SizedBox(height: 5,),

              RoleCard(
                  icon: Icons.person,
                  title: "Login as Teacher",
                  description:  "Manage classes, track attendance, and insights",
                  color: const Color(0xFFF59E0B),
                  onTap: (){
                    // navigation to teacher login
                    navigatorWithAnimation(context, TeacherSignUpPage());
                  }
              ),

            ],
          ),

          // Bottom section
          Padding(
            padding: const EdgeInsets.only(left: 27.0,bottom: 5.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    // open help/support

                  },

                  child: Text(
                    "Need help? Contact support",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8,)
              ],
            ),
          )
        ],
      ),

    ),
  );
  }
}

class RoleCard extends StatefulWidget{
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });
  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 10.0,bottom: 40.0),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering){
          setState(() {
            _isHovered=hovering;
          });
        },

        borderRadius: BorderRadius.circular(16),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered?[
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ]:[
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),

          child: Column(
            children: [
              Icon(widget.icon, size: 40, color: widget.color,),
              const SizedBox(height: 10,),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 6,),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}