import 'package:communitycarev4/pages/user/explore_more.dart';
import 'package:communitycarev4/pages/user/recent_complaint.dart';
import 'package:communitycarev4/pages/user/report_issues.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 247, 126),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/s1.jpg',
            fit: BoxFit.cover,
          ),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'Community Care',
                style: TextStyle(fontSize: 39.0, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 30.0),

              // Buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to ReportIssuePage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportIssueForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text('Report Issue', style: TextStyle(fontSize: 24.0)),
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to RecentComplaintsPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecentComplaintsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text('Recent Complaints', style: TextStyle(fontSize: 24.0)),
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to ExploreMorePage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExploreMorePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text('Explore More', style: TextStyle(fontSize: 24.0)),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ],
      ),
    );
  }
}
