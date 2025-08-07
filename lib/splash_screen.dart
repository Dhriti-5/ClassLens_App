import 'package:classlens/login_selector.dart';
import 'package:flutter/material.dart';
import 'login_selector.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _textOpacity = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF9EC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        child: Lottie.asset(
                          'assets/animations/face_scan.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward().whenComplete(() {
                                Future.delayed(const Duration(seconds: 3), () {
                                  if(mounted){
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => LoginSelector()),
                                    );
                                  }
                                });
                              });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),

                    AnimatedOpacity(
                      opacity: _textOpacity,
                      duration: const Duration(milliseconds: 3000),

                      child: Column(
                        children: [

                          Text(
                            "ClassLens",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),

                          Text(
                            "Attendance, automated",
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
