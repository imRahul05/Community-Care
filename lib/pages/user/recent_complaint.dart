import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// Data model for an issue
class Issue {
  final String id;
  late final String title;
  late final String description;
  late final DateTime submissionDate;
  late final String imageURL;
  int votes;
  Set<String> voters; // Use a set to track unique voters
  String status; // Add status property

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.submissionDate,
    required this.imageURL,
    this.votes = 0,
    Set<String>? voters,
    required this.status, // Include status in the constructor
  }) : voters = voters ?? {}; // Initialize with an empty set if not provided

  // Helper method to check if a user has voted for this issue
  bool hasUserVoted(String userId) {
    return voters.contains(userId);
  }
}

class RecentComplaintsPage extends StatefulWidget {
  @override
  _RecentComplaintsPageState createState() => _RecentComplaintsPageState();
}

class _RecentComplaintsPageState extends State<RecentComplaintsPage> {
  List<Issue> issues = [];
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('issues');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Fetch all issues from the database
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
            voters: Set<String>.from((values['voters'] ?? {}).keys),
            votes: values['votes'] ?? 0,
            status: values['status'] ?? 'In-Progress',
          );

          setState(() {
            issues.add(newIssue);
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

  void _voteForIssue(Issue issue) async {
    User? user = _auth.currentUser;
    if (user != null && !issue.hasUserVoted(user.uid)) {
      setState(() {
        issue.votes++;
        issue.voters.add(user.uid); // Add the user to the set of voters
      });

      await databaseReference.child(issue.id).update({
        'votes': issue.votes,
        'voters': Map.fromIterable(issue.voters, key: (e) => e, value: (_) => true),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voted for the issue (${issue.title})'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already voted for this issue'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Complaints'),
      ),
      body: issues.isEmpty
          ? Center(
              child: Text('Database is Empty'),
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
                        Text('Votes: ${issue.votes}'),
                        if (issue.imageURL.isNotEmpty)
                          Image.network(
                            issue.imageURL,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _voteForIssue(issue);
                          },
                          child: Text('Vote'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IssueDetailsPage(issue: issue),
                              ),
                            );
                          },
                          child: Text('Details'),
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

class IssueDetailsPage extends StatelessWidget {
  final Issue issue;

  IssueDetailsPage({required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issue Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Issue ID: ${issue.id}'),
            Text('Title: ${issue.title}'),
            Text('Description: ${issue.description}'),
            Text('Submission Date: ${issue.submissionDate}'),
            Text('Status: ${issue.status}'), // Display status
            if (issue.imageURL.isNotEmpty)
              Image.network(
                issue.imageURL,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            //SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     issue.votes++;
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text('Voted for the issue (${issue.title})'),
                  SizedBox(height: 16),
                  ElevatedButton(
                  onPressed: null, // Set onPressed to null to disable the button
                  child: Text('Vote (${issue.votes})'),
                      ),

                 // ),
               // );
              //},
            // child: Text('Vote (${issue.votes})'),
           // ),
          ],
        ),
      ),
    );
  }
}
