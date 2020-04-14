import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestures and Animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  int numTaps = 0;
  int numDoubleTaps = 0;
  int numLongPress = 0;
  double posX = 0.0;
  double posY = 0.0;
  double boxsize = 0.0;
  final double fullBoxSize = 150.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    animation.addListener(() {
      setState(() {
        boxsize = fullBoxSize * animation.value;
      });
      center(context);
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (posX == 0.0) {
      // app build for the first time
      center(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestures and Animations"),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            numTaps++;
          });
        },
        onDoubleTap: () {
          setState(() {
            numDoubleTaps++;
          });
        },
        onLongPress: () {
          setState(
            () {
              numLongPress++;
            },
          );
        },
        onVerticalDragUpdate: (DragUpdateDetails value) {
          setState(() {
            double delta = value.delta.dy;
            posY += delta;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails value) {
          setState(() {
            double delta = value.delta.dx;
            posX += delta;
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: posX,
              top: posY,
              child: Container(
                width: boxsize,
                height: boxsize,
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Taps: $numTaps - Double Taps: $numDoubleTaps - Long presses: $numLongPress",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void center(BuildContext context) {
    Size sizeOfApp = MediaQuery.of(context).size;
    posX = (sizeOfApp.width / 2) - boxsize / 2;

    posY = (sizeOfApp.width / 2) - boxsize / 2 - 30.0;
    // Subtracted 30 to give some space to the appbar

    setState(() {
      posX = posX;
      posY = posY;
    });
  }
}

// An Animation controller is an object that generates new value whenever the hardware is ready for a new frame.
// It generates numbers from 0.0 to 1.0 in the time specified.
// the vsync property makes sure that if an object is not visible, it does not waste the system resources.

// A CurvedAnimation defines the animation's progress as a non-linear curve.
// the addListener value of the animation is called whenever the values of the animation changes.

// the forward() method makes the animation begin.

// In object oriented programming languages a mixin is a method that can be used
// by other classes w/o having to be the parent class of those other classes
// Thats why we use the with clause in Flutter beacuse in a away we are including
// including the class, not inheriting from it.

// The SingleTickerProviderStateMixin provides one ticker.
// A ticker calls its callback once per animation frame.
