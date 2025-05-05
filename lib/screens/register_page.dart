import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sissifit/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var registerKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = ""; // Added for password confirmation
  String username = ""; // Added for username
  bool obscurePassword = true;
  bool obscureConfirmPassword = true; // Added for confirm password visibility
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
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
        child: SingleChildScrollView(
          // Use SingleChildScrollView to prevent overflow on small screens
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Form(
              key: registerKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 24, // Increased vertical padding
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Removed mainAxisAlignment.center to align to top in SingleChildScrollView
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up",
                        style: textTh.titleLarge!.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // Add spacing

                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(hintText: "Username"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        username = value ?? "";
                      },
                    ),
                    const SizedBox(height: 14), // Add spacing

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Your Email"),
                      onSaved: (value) {
                        email = value ?? "";
                      },
                    ),
                    const SizedBox(height: 14), // Add spacing

                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Input proper password";
                        }
                        if (value.trim().length < 6) {
                          // Check password length
                          return "Password must be at least 6 characters long";
                        }
                        if (passwordConfirmController.text !=
                            passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      controller: passwordController,
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
                        password = value ?? "";
                      },
                    ),
                    const SizedBox(height: 14), // Add spacing

                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Input proper password confirmation";
                        }
                        if (passwordConfirmController.text !=
                            passwordController.text) {
                          return "Passwords do not match";
                        }

                        return null;
                      },
                      controller: passwordConfirmController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      onSaved: (value) {
                        confirmPassword = value ?? "";
                      },
                    ),
                    const SizedBox(height: 20), // Add spacing

                    Align(
                      // Center the button
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          fixedSize: Size(size.width * 0.8, 60), // Adjust size
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            _registerUser, // Call the registration function
                        child:
                            isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Sign Up",
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
                                text: "Already have an account?",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const TextSpan(text: '\t\t'),
                              TextSpan(
                                text: "Sign In",
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
                                            builder: (_) => LoginPage(),
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
    );
  }

  // Function to handle user registration
  Future<void> _registerUser() async {
    // Validate the form fields

    if (registerKey.currentState!.validate()) {
      registerKey.currentState!.save(); // Save the form fields
      setState(() {
        isLoading = true;
      });
      try {
        // Attempt to create a new user with email and password using Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.trim(),
              password: password.trim(),
            );

        // Get the newly created user's UID
        String userId = userCredential.user!.uid;

        // Save additional user data (like username) to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': username.trim(),
          // Add other initial user data here if needed
        });
        setState(() {
          isLoading = false;
        });
        // If registration is successful, show a success message and navigate back to login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration Successful! Please log in.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back to the login page
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase Authentication errors
        setState(() {
          isLoading = false;
        });
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        } else {
          message = e.message ?? 'An unknown authentication error occurred.';
        }
        // Show an error message to the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration Failed: $message'),
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
