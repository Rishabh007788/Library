import 'dart:convert';
import 'package:first_project/screens/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/app_colors.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final Map userData;

  const EditProfile({required this.userData, Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String user_id = '';
  String _warningMessage = '';
  bool _isLoading = false;

  void getUserId() async {
    String? fetchedUserId = await SessionManager.getUserId();

    if (fetchedUserId != null) {
      setState(() {
        user_id = fetchedUserId;
      });
    } else {
      print('User ID not found');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    _nameController = TextEditingController(text: widget.userData['name']);
    _mobileController = TextEditingController(text: widget.userData['mobile']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (user_id.isEmpty) {
        setState(() {
          _warningMessage = 'User ID is not available.';
        });
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await http.put(
          Uri.parse('http://192.168.29.145:8888/update?user_id=$user_id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': _nameController.text,
            'email': _emailController.text,
            'mobile': _mobileController.text,
            'old_password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          print('Update successful: $responseBody');
          _showSuccessDialog();
        } else {
          setState(() {
            _warningMessage = 'Failed to update: ${response.body}';
          });
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Updated'),
          content: Text('Go to home page.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, 'home'); // Navigate to home page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back arrow color here
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _mobileController,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                        if (_warningMessage.isNotEmpty) // Display warning message if not empty
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _warningMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
