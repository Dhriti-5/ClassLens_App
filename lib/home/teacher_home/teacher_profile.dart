import 'dart:ui';
import 'package:flutter/material.dart';


const Color primaryTextColor = Color(0xFF1A2533);
const Color secondaryTextColor = Color(0xFF6C757D);
const Color cardBackgroundColor = Colors.white;
const Color primaryBackgroundColor = Color(0xFFF0F4F8);
const Color accentColor = Color(0xFF4A90E2);


const Color circleColor1 = Color.fromARGB(255, 178, 218, 255);
const Color circleColor2 = Color.fromARGB(255, 201, 247, 222);

class TeacherProfile extends StatelessWidget {
  final String teacherName;
  final String teacherEmail;
  final int totalSubjects;
  final int totalStudents;
  final String department;
  final String dateJoined;

  const TeacherProfile({
    super.key,
    this.teacherName = "Yash Solanki",
    this.teacherEmail = "yash.solanki@example.com",
    this.totalSubjects = 5,
    this.totalStudents = 142,
    this.department = "Computer Science",
    this.dateJoined = "October 20, 2025",
  });

  Widget _buildBlurredAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            padding: EdgeInsets.only(
              top: topPadding,
              left: 4.0,
              right: 16.0,
            ),
            height: kToolbarHeight + topPadding,
            color: Colors.transparent,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: primaryTextColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(

      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            color: primaryBackgroundColor,
          ),


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


          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + topPadding + 20,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: _buildProfileCard(context),
          ),

          // Blurred AppBar
          _buildBlurredAppBar(context),
        ],
      ),
    );
  }


  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks to content
        children: [
          _buildCardHeader(),
          const SizedBox(height: 50 + 16),
          Text(
            teacherName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            teacherEmail,
            style: const TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatsRow(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: secondaryTextColor.withOpacity(0.2)),
          ),
          _buildDetailRow(
            icon: Icons.school_outlined,
            title: "Department",
            value: department,
          ),
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            title: "Date Joined",
            value: dateJoined,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            gradient: LinearGradient(
              colors: [accentColor, Color(0xFF6E8CF3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: 120 - 50,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundColor: primaryBackgroundColor,
              child: Text(
                teacherName.isNotEmpty ? teacherName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Total Subjects", totalSubjects.toString()),
          Container(
            width: 1,
            height: 40,
            color: secondaryTextColor.withOpacity(0.2),
          ),
          _buildStatItem("Total Students", totalStudents.toString()),
        ],
      ),
    );
  }


  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }


  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}