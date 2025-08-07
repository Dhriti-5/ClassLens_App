import 'package:flutter/material.dart';

class SnackBarExample extends StatelessWidget {
  const SnackBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar Example'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show SnackBar'),
          onPressed: () {
            // 1. Create the SnackBar
            final snackBar = SnackBar(
              // 2. The content of the SnackBar
              content: const Text('This is a SnackBar!'),
              // 3. (Optional) Add an action button
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );

            // 4. Find the ScaffoldMessenger and show the SnackBar
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}

class LoginSelector extends StatefulWidget {
  const LoginSelector({super.key});

  @override
  State<LoginSelector> createState() => _LoginSelectorState();
}

class _LoginSelectorState extends State<LoginSelector> {

  double _rotationX = 0;
  double _rotationY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gesture Detector"),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(

        child: GestureDetector(
          onTap: (){
            final snackBar = SnackBar(content: const Text("You tapped the container"),
            duration: const Duration(seconds: 2),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          onPanUpdate: (details) {

            setState(() {
              _rotationY += details.delta.dx / 100;
              _rotationX -= details.delta.dy / 100;
            });
          },
          onPanEnd: (details) {

            setState(() {
              _rotationX = 0;
              _rotationY = 0;
            });
          },
          child:
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 300,
            height: 300,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotationX)
              ..rotateY(_rotationY),
            transformAlignment: FractionalOffset.center,
            decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  )
                ]),
            child: const Center(
              child: Text(
                "Drag Me!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}