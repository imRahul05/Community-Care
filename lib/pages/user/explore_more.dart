import 'package:communitycarev4/pages/user/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: ExploreMorePage(),
  ));
}

class ExploreMorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore More'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Pothole Awareness'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                navigateToDetailsPage(
                  context,
                  'Pothole Awareness',
                  'Potholes pose significant threats to road safety, presenting dangers that range from vehicle damage to potential hazards for drivers and pedestrians alike. These depressions or holes in road surfaces are often caused by the combined effects of weathering, traffic, and subpar road maintenance. The impact on road safety is multifaceted; vehicles navigating pothole-ridden roads may experience tire blowouts, misalignments, or even more severe damages. For drivers, unexpected encounters with potholes can lead to sudden swerving or braking, increasing the risk of accidents. Pedestrians may also face challenges navigating sidewalks and crosswalks affected by potholes, compromising their safety. Addressing pothole-related concerns becomes crucial not only for preserving road infrastructure but, more importantly, for safeguarding the well-being of individuals on the road.',
                  'https://www.potholeraja.com/',
                );
              },
            ),
            ListTile(
              title: Text('Overflowing Garbage Issues'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                navigateToDetailsPage(
                  context,
                  'Overflowing Garbage Issues',
                  'Overflowing garbage brings forth a myriad of consequences that extend beyond the immediate aesthetic displeasure. The accumulation of waste beyond the capacity of disposal systems poses environmental, health, and societal challenges. Environmentally, it can lead to soil and water contamination as well as harm to wildlife, disrupting ecosystems. The release of harmful substances from decomposing waste can contribute to air pollution. From a public health perspective, overflowing garbage becomes a breeding ground for pests and disease vectors, posing health risks to nearby residents. Societally, the issue reflects on community well-being, influencing the overall quality of life and neighborhood aesthetics.',
                  'https://kleentools.com/blogs/kleen-opener-blog/the-problem-with-overflowing-garbage-an-important-piece-of-the-life-cycle-of-waste',
                );
              },
            ),
            ListTile(
              title: Text('Impact on Animals'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                navigateToDetailsPage(
                  context,
                  'Impact on Animals',
                  'The impact of garbage on wildlife is profound, posing severe threats to various species and ecosystems. Improper disposal of waste, especially plastic, can lead to entanglement, ingestion, and habitat disruption for animals. Marine life, in particular, faces significant challenges, as discarded plastic finds its way into oceans, endangering marine creatures through ingestion or entanglement. Birds, terrestrial mammals, and aquatic species often mistake plastic debris for food, leading to detrimental consequences for their health and well-being.',
                  'https://www.sciencedirect.com/science/article/abs/pii/S016758771000228X',
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Explore the Issues',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.network(
              'https://www.example.com/cover-image.jpg', // Replace with your cover image URL
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to the Explore More page! Choose a topic to learn more and raise awareness:',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                navigateToDetailsPage(
                  context,
                  'Pothole Awareness',
                  'Potholes pose significant threats to road safety, presenting dangers that range from vehicle damage to potential hazards for drivers and pedestrians alike. These depressions or holes in road surfaces are often caused by the combined effects of weathering, traffic, and subpar road maintenance. The impact on road safety is multifaceted; vehicles navigating pothole-ridden roads may experience tire blowouts, misalignments, or even more severe damages.',
                  'https://www.potholeraja.com/',
                );
              },
              child: Text('Pothole Awareness'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToDetailsPage(
                  context,
                  'Overflowing Garbage Issues',
                  'Overflowing garbage brings forth a myriad of consequences that extend beyond the immediate aesthetic displeasure. The accumulation of waste beyond the capacity of disposal systems poses environmental, health, and societal challenges. Environmentally, it can lead to soil and water contamination as well as harm to wildlife, disrupting ecosystems. The release of harmful substances from decomposing waste can contribute to air pollution.',
                  'https://kleentools.com/blogs/kleen-opener-blog/the-problem-with-overflowing-garbage-an-important-piece-of-the-life-cycle-of-waste',
                );
              },
              child: Text('Overflowing Garbage Issues'),
            ),
            ElevatedButton(
              onPressed: () {
                navigateToDetailsPage(
                  context,
                  'Impact on Animals',
                  'The impact of garbage on wildlife is profound, posing severe threats to various species and ecosystems. Improper disposal of waste, especially plastic, can lead to entanglement, ingestion, and habitat disruption for animals. Marine life, in particular, faces significant challenges, as discarded plastic finds its way into oceans, endangering marine creatures through ingestion or entanglement.',
                  'https://www.sciencedirect.com/science/article/abs/pii/S016758771000228X',
                );
              },
              child: Text('Impact on Animals'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToDetailsPage(BuildContext context, String title, String description, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          title: title,
          description: description,
          url: url,
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const DetailsPage({
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: <Widget>[
          // Add an IconButton to navigate back to "dashboard.dart"
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Navigate to "dashboard.dart"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                openURL(url);
              },
              child: Text('Learn More'),
            ),
          ],
        ),
      ),
    );
  }

  void openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}
