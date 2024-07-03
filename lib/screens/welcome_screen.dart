import 'package:flutter/material.dart';

Color myColor = const Color.fromARGB(255, 82, 46, 46);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background and main image container
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                decoration: BoxDecoration(
                  color: myColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(70)),
                ),
                child: Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      myColor.withOpacity(0.3), // Adjust opacity to your preference
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      "assets/study_table3.jpg",
                      width: MediaQuery.of(context).size.width * 0.95, // Adjust width for better scaling
                      height: MediaQuery.of(context).size.height * 0.4, // Adjust height for better scaling
                      fit: BoxFit.cover, // Ensure the image fits well
                    ),
                  ),
                ),
              ),
              // Bottom container
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.666,
                  decoration: BoxDecoration(
                    color: myColor,
                  ),
                ),
              ),
              // Bottom content container
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.666,
                  padding: const EdgeInsets.only(top: 40, bottom: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Swayam Pustakalaya",
                        style: TextStyle(
                          color: myColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Learning is everything, and learning with Swayam is pleasure. Learn the way you want",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Material(
                        color: myColor,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 50,
                            ),
                            child: const Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("I already have an account!",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, 'login');
                              },
                              child: Text('Sign in',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue[900],
                                    fontSize: 16,
                                    color: Colors.blue[900]
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 20), // Adjust padding as needed
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30, // Adjust the size as needed
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'home');
                    },
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Center(
//         child: Text('Login Screen'),
//       ),
//     );
//   }
// }
