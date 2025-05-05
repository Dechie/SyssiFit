import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sissifit/screens/home.dart';
import 'package:sissifit/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loginKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool obscurePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'FitTrack',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 18.0,
                  horizontal: 24,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Form(
                    key: loginKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Login",
                              style: textTh.titleLarge!.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // Add spacing
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                // Trim whitespace before checking empty
                                return 'Please enter your email';
                              }
                              // Regular expression to validate email format
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                // Trim before matching regex
                                return 'Please enter a valid email address';
                              }
                              return null; // Return null if the input is valid
                            },
                            decoration: const InputDecoration(
                              hintText: "Your Email",
                            ),
                            onSaved: (value) {
                              email = value ?? ""; // Save trimmed value
                            },
                          ),
                          const SizedBox(height: 14), // Add spacing

                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                // Trim whitespace before checking empty
                                return "Input proper password";
                              }
                              return null;
                            },
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              hintText: "Your Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            onSaved: (value) {
                              password = value ?? ""; // Save trimmed value
                            },
                          ),
                          const SizedBox(height: 20), // Add spacing
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                fixedSize: Size(
                                  size.width * 0.8,
                                  60,
                                ), // Adjust size for better responsiveness
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _loginUser, // Call the login function
                              child:
                                  isLoading
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        "Log In",
                                        style: textTh.titleLarge!.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 20), // Add spacing
                          Center(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: RichText(
                                textDirection: TextDirection.ltr,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Don't have an account?",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const TextSpan(text: '\t\t'),
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => RegisterPage(),
                                                ),
                                              );
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Add a button to navigate to the registration page
          ],
        ),
      ),
    );
  }

  // Function to handle user login
  Future<void> _loginUser() async {
    // Validate the form fields

    if (loginKey.currentState!.validate()) {
      loginKey.currentState!
          .save(); // Save the form fields to update email and password variables
      setState(() {
        isLoading = true;
      });
      try {
        // Attempt to sign in with email and password using Firebase Auth
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), // Trim whitespace from email
          password: password.trim(), // Trim whitespace from password
        );

        // If login is successful, navigate to the HomePage
        // Use pushReplacement to prevent going back to the login page
        setState(() {
          isLoading = true;
        });
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase Authentication errors
        setState(() {
          isLoading = true;
        });
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        } else {
          message = e.message ?? 'An unknown authentication error occurred.';
        }
        // Show an error message to the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Failed: $message'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        // Handle any other potential errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occurred: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }
}
