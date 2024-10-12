import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


// issue.dart

class Issue {
  final String id;
  late final String title;
  late final String description;
  late final DateTime submissionDate;
  late final String imageURL;
  String status;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.submissionDate,
    required this.imageURL,
    this.status = 'In-Progress',
  });
}
// image_view_page.dart


class ImageViewPage extends StatelessWidget {
  final String imageURL;

  ImageViewPage({required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Size Image'),
      ),
      body: Center(
        child: Image.network(
          imageURL,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
// dashboard_screen.dart



class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Issue> issues = [];
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('issues');
  final FirebaseAuth_auth = FirebaseAuth.instance;

  int selectedIssueIndex = -1;

  @override
  void initState() {
    super.initState();
    databaseReference.onChildAdded.listen(
      (event) {
        try {
          Map<dynamic, dynamic> values =
              Map.from(event.snapshot.value as Map);
          Issue newIssue = Issue(
            id: event.snapshot.key!,
            title: values['issuerName'] ?? '',
            description: values['description'] ?? '',
            submissionDate: DateTime.now(),
            imageURL: values['imageURL'] ?? '',
            status: values['status'] ?? 'In-Progress',
          );

          setState(() {
            var existingIssue = issues.firstWhere(
              (issue) => issue.id == newIssue.id,
              orElse: () => Issue(
                id: '',
                title: '',
                description: '',
                submissionDate: DateTime.now(),
                imageURL: '',
              ),
            );

            if (existingIssue.id.isEmpty) {
              issues.add(newIssue);
            } else {
              existingIssue.title = newIssue.title;
              existingIssue.description = newIssue.description;
              existingIssue.submissionDate = newIssue.submissionDate;
              existingIssue.imageURL = newIssue.imageURL;
              existingIssue.status = newIssue.status;
            }
          });
        } catch (e, stackTrace) {
          print('Error processing data from the database: $e\n$stackTrace');
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        print('Error listening to the database: $error\n$stackTrace');
      },
    );
  }

  void _updateIssueStatus(Issue issue, String newStatus, int index) async {
    await databaseReference.child(issue.id).update({
      'status': newStatus,
    });

    setState(() {
      issues[index].status = newStatus;
      selectedIssueIndex = index;
    });
  }

  void _showFullSizeImage(String imageURL) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewPage(imageURL: imageURL),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Complaints By Users'),
      ),
      body: issues.isEmpty
          ? Center(
              child: Text('Database is empty'),
            )
          : ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(issue.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Submission Date: ${issue.submissionDate}'),
                        Text('Status: ${issue.status}'),
                        if (issue.imageURL.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _showFullSizeImage(issue.imageURL);
                            },
                            child: Image.network(
                              issue.imageURL,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Issue "${issue.title}" marked as In-Progress',
                                ),
                              ),
                            );
                            _updateIssueStatus(issue, 'In-Progress', index);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return issue.status == 'In-Progress'
                                    ? Colors.yellow
                                    : Colors.white;
                              },
                            ),
                          ),
                          child: Text('In-Progress'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Issue "${issue.title}" marked as Success',
                                ),
                              ),
                            );
                            _updateIssueStatus(issue, 'Success', index);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return issue.status == 'Success'
                                    ? Colors.green
                                    : Colors.white;
                              },
                            ),
                          ),
                          child: Text('Success'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
