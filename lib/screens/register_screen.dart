import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'model.dart'; // Import the Url class

Color myColor = const Color.fromARGB(255, 82, 46, 46);

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _warningMessage = '';
  bool _isLoading = false;

  Future<void> signupUser(String name, String email, String mobile, String password) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/register'), // Using the register URL from Url class
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Signup successful: $responseBody');
      _showSuccessDialog();
    } else {
      setState(() {
        _warningMessage = 'Failed to signup: ${response.body}';
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String mobile = _mobileController.text;
      String password = _passwordController.text;

      bool isEmailValid = EmailValidator.validate(email);
      if (!isEmailValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid email address'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      signupUser(name, email, mobile, password);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Registered successfully. Go to home page.'),
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

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _mobileController.clear();
      _passwordController.clear();
      _formKey.currentState?.reset();
      _warningMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 94, left: 33),
                        child: const Text(
                          'Create\n    Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 80, left: 43, right: 33),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Name',
                                fillColor: Colors.grey[250],
                                filled: true,
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Email Id',
                                fillColor: Colors.grey[250],
                                filled: true,
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile number';
                                } else if (value.length != 10) {
                                  return 'Mobile number should be 10 digits';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Mobile Number',
                                fillColor: Colors.grey[250],
                                filled: true,
                                prefixIcon: const Icon(Icons.phone_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Password..',
                                fillColor: Colors.grey[250],
                                filled: true,
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 27,
                                    color: myColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: myColor,
                                  child: IconButton(
                                    onPressed: _submitForm,
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "I already have an account!",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'login');
                                  },
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue[900],
                                      fontSize: 16,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                              ],
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
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.green[600],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
