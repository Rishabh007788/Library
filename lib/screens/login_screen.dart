import 'dart:convert';
import 'package:first_project/screens/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Color myColor = const Color.fromARGB(255, 82, 46, 46);

class Mylogin extends StatefulWidget {
  const Mylogin({super.key});

  @override
  _MyloginState createState() => _MyloginState();
}

class _MyloginState extends State<Mylogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _warningMessage = '';
  bool _isLoading = false;

  Future<void> loginUser(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/login'),
      body: jsonEncode(<String, String>{
        'email': email,
        'password' : password,
        'role' : 'user',
    }),
    );
    setState(() {
      _isLoading=false;
    });
    if(response.statusCode==200){
      final responseBody = jsonDecode(response.body);
      final String userId = responseBody['user_id'];
      SessionManager.saveUserId(userId);
      Navigator.of(context).pop(); // Close the dialog
      Navigator.pushNamed(context, "home");
    } else {
      setState(() {
        _warningMessage = 'login failed : ${response.body}';
      });
    }
  }

  void _submitForm(){
    String email = _emailController.text;
    String password = _passwordController.text;
    loginUser(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/register.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 33, top: 90),
                child: const Text(
                  'Welcome\n           Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _emailController.clear();
                    _passwordController.clear();
                    _warningMessage = '';
                  });
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4,
                      left: 43,
                      right: 33,
                    ),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email..',
                                  fillColor: Colors.grey[250],
                                  filled: true,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 140),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue[900],
                                fontSize: 15,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_warningMessage.isNotEmpty)
                          Text(
                            _warningMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Log In',
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _submitForm();
                                    //Navigator.pushNamed(context, 'home');
                                  } else {
                                    setState(() {
                                     _warningMessage = 'Please fix the errors above.';
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "I don't have an account!",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue[900],
                                  fontSize: 15,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
