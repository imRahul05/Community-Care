import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Issue Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReportIssueForm(),
    );
  }
}

class ReportIssueForm extends StatefulWidget {
  @override
  _ReportIssueFormState createState() => _ReportIssueFormState();
}

class _ReportIssueFormState extends State<ReportIssueForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _issueNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _issueCauseController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;
  Position? _currentLocation;
  int selectedIssueIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issue Report Form'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 251, 241, 134),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: [
                    'Water Sanitation',
                    'Air Sanitation',
                    'Waste Management',
                    'Transmitter(Mosquitoes,Rodents)'
                  ].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Issue Category*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the issue category';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _issueNameController,
                  decoration: InputDecoration(
                    labelText: 'Issuer Name*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the issuer name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _issueCauseController,
                  decoration: InputDecoration(
                    labelText: 'Issue Cause',
                  ),
                ),

                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.camera),
                  child: Text('Upload Image from Camera'),
                ),

                ElevatedButton(
                  onPressed: () => _getImage(ImageSource.gallery),
                  child: Text('Upload Image from Gallery'),
                ),

                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _resetForm,
                      child: Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: _getCurrentLocation,
                      child: Text('Get Location'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _selectedCategory = null;
      _selectedImage = null;
      _issueNameController.clear();
      _descriptionController.clear();
      _issueCauseController.clear();
      _currentLocation = null;
      selectedIssueIndex = -1;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _uploadDataToFirebase();
      setState(() {
        selectedIssueIndex = -1; // Reset selected issue index
      });
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 107, 240, 111),
          content: Text(
            'Issue reported successfully!',
            style: TextStyle(color: Color.fromARGB(255, 237, 8, 8)),
          ),
        ),
      );
    }
  }

  Future<void> _uploadDataToFirebase() async {
    var storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('issue_images/${Path.basename(_selectedImage!.path)}');
    await storageRef.putFile(_selectedImage!);

    var downloadUrl = await storageRef.getDownloadURL();

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child('issues').push().set({
      'category': _selectedCategory,
      'issuerName': _issueNameController.text,
      'description': _descriptionController.text,
      'issueCause': _issueCauseController.text,
      'imageURL': downloadUrl,
      'latitude': _currentLocation?.latitude,
      'longitude': _currentLocation?.longitude,
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentLocation = position;
      });
    } catch (e) {
      // Handle errors, if any
      print('Error getting location: $e');
    }
  }
}
