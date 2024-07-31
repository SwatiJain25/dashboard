import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true; // Set initial mode to dark

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LandingPage(
        isDarkMode: isDarkMode,
        toggleDarkMode: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleDarkMode;

  LandingPage({required this.isDarkMode, required this.toggleDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Features',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              toggleDarkMode();
            },
            activeTrackColor: Colors.grey,
            activeColor: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildFeatureBox(
                      'assets/images/p1.jpg',
                      'Feature 1',
                      'This is the description for Feature 1. It explains the primary functionality and benefits of this feature in detail.',
                      context,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureBox(
                      'assets/images/p2.jpg',
                      'Feature 2',
                      'This is the description for Feature 2. It explains how this feature enhances user experience and provides added value.',
                      context,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureBox(
                      'assets/images/p3.jpg',
                      'Feature 3',
                      'This is the description for Feature 3. It highlights the unique aspects and key advantages of using this feature.',
                      context,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                'How it Works',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Here is a brief description of how the app works. '
                'It is designed to be user-friendly and efficient, '
                'providing all necessary functionalities with ease.',
              ),
              SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  double lineWidth;
                  if (constraints.maxWidth < 600) {
                    lineWidth = 30;
                  } else if (constraints.maxWidth < 800) {
                    lineWidth = 50;
                  } else {
                    lineWidth = 70;
                  }

                  return Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: lineWidth,
                    runSpacing: 16.0,
                    children: [
                      _buildCircularPoint('1', 'Input Your Vision',
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                      _buildCircularPoint('2', 'Get your Workflow',
                          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                      _buildCircularPoint('3', 'Customize your Workflow',
                          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBox(String imagePath, String description, String details,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFeatureDialog(context, description, details);
      },
      child: Column(
        children: [
          Container(
            width: 190, // Adjust width to make the box slightly bigger
            height: 190, // Adjust height to make the box slightly bigger
            decoration: BoxDecoration(
              border:
                  Border.all(color: isDarkMode ? Colors.white : Colors.black),
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            details,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCircularPoint(String number, String title, String description) {
    return CircularPoint(
      number: number,
      title: title,
      description: description,
    );
  }

  Widget _buildHorizontalLine(double width) {
    return Container(
      height: 1,
      width: width,
      color: Colors.grey,
    );
  }
}

class CircularPoint extends StatefulWidget {
  final String number;
  final String title;
  final String description;

  CircularPoint({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  _CircularPointState createState() => _CircularPointState();
}

class _CircularPointState extends State<CircularPoint>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 30.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
          _controller.reverse();
        });
      },
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: <Color>[
                  Colors.lightBlue,
                  const Color.fromARGB(255, 3, 73, 131)
                ],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: CircleAvatar(
              radius: _animation.value,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.blue, // Gradient border color
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.number,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18, // Increased font size
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            widget.description,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
