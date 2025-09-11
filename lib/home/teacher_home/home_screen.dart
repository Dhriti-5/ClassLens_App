import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:classlens/login/login_selector.dart';
import 'package:classlens/global/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:classlens/home/teacher_home/take_attendance.dart';
import '../../page_animations/slide_animation.dart';


const Color primaryBackgroundColor = Color(0xFFF0F4F8);
const Color cardBackgroundColor = Colors.white;
const Color primaryTextColor = Color(0xFF1A2533);
const Color secondaryTextColor = Color(0xFF6C757D);
const Color accentColor = Color(0xFF4A90E2);
const Color attentionColor = Color(0xFFE53935); // For low attendance
const Color warningColor = Color(0xFFFDD835); // For medium attendance
const Color successColor = Color(0xFF43A047); // For high attendance

const Color circleColor1 = Color.fromARGB(255, 178, 218, 255);
const Color circleColor2 = Color.fromARGB(255, 201, 247, 222);


class Home extends StatefulWidget {
  final String? teacherName;
  const Home({Key?key, this.teacherName}):super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String? teacherName;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: cardBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          icon: const Icon(Icons.logout_rounded, color: attentionColor, size: 40),
          title: const Text(
            'Confirm Logout',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: TextStyle(color: secondaryTextColor),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: secondaryTextColor, fontSize: 16)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            const SizedBox(width: 8),
            // Logout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: attentionColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Logout', style: TextStyle(fontSize: 16)),
              onPressed: () async {

                print("Logout confirmed");
                Navigator.of(dialogContext).pop();
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("rememberMe", false);
                pref.remove("teacherName");
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginSelector()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if(status.isGranted){
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Camera permission granted")));
      navigatorWithAnimation(context,AttendanceUploadScreen());
      print("Camera permission granted");
    }
    else if(status.isDenied){
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Camera permission denied")));
      print("Camera permission denied");
    }
    else if(status.isPermanentlyDenied){
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Camera permission denied")));
      print("Camera permission permanently denied");
    }
  }

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

          CustomScrollView(
            slivers: [
              _buildSliverAppBar(screenSize),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(

                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TakeAttendanceCard(onPressed: _requestCameraPermission,),

                          const SizedBox(height: 24),
                          const RecentActivitySection(),
                          const SizedBox(height: 24),
                          const MyClassesSection(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  SliverAppBar _buildSliverAppBar(Size screenSize) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      pinned: true,
      elevation: 0,
      expandedHeight: screenSize.height * 0.15,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.teacherName??userName,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: cardBackgroundColor,
                  elevation: 8,
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutDialog(context);
                    }
                    if (value == 'profile') {
                      // TODO: Implement navigation to profile page
                      print("Profile tapped");
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: ListTile(
                        leading: Icon(Icons.person_outline, color: secondaryTextColor),
                        title: Text('Profile', style: TextStyle(color: primaryTextColor)),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.logout, color: attentionColor),
                        title: Text('Logout', style: TextStyle(color: attentionColor)),
                      ),
                    ),
                  ],

                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: accentColor, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Students',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Reports',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: accentColor,
      unselectedItemColor: secondaryTextColor,
      backgroundColor: cardBackgroundColor,
      elevation: 10,
      onTap: _onItemTapped,
    );
  }
}

class TakeAttendanceCard extends StatelessWidget {
  final VoidCallback onPressed;
  const TakeAttendanceCard({super.key,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.camera_alt_outlined, size: 50, color: accentColor),
          const SizedBox(height: 12),
          const Text(
            "Ready to start your class?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tap below to begin the AI attendance scan.",
            textAlign: TextAlign.center,
            style: TextStyle(color: secondaryTextColor, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Take Attendance'),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        const SizedBox(height: 12),

        _buildActivityItem("Math - Grade 5", "Today, 9:00 AM", 95, successColor),
        const SizedBox(height: 10),
        _buildActivityItem("Science - Grade 6", "Yesterday, 1:00 PM", 88, warningColor),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, int percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(Icons.check_circle_outline, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: secondaryTextColor, fontSize: 12)),
              ],
            ),
          ),
          Text(
            "$percentage%",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
          ),
        ],
      ),
    );
  }
}

class MyClassesSection extends StatelessWidget {
  const MyClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Classes",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        const SizedBox(height: 12),
        // Example Class Items - Replace with your data model
        _buildClassItem("English - Grade 7", 28, 92),
        const SizedBox(height: 10),
        _buildClassItem("History - Grade 8", 32, 74),
        const SizedBox(height: 10),
        _buildClassItem("Physics - Grade 10", 25, 65),
      ],
    );
  }

  Widget _buildClassItem(String title, int studentCount, int percentage) {
    Color progressColor = successColor;
    if (percentage < 75) progressColor = attentionColor;
    else if (percentage < 90) progressColor = warningColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryTextColor)),
              Text("$percentage%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: progressColor)),
            ],
          ),
          const SizedBox(height: 8),
          Text("$studentCount Students", style: const TextStyle(color: secondaryTextColor, fontSize: 12)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: progressColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

