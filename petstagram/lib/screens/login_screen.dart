// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:petstagram/resources/auth_methods.dart';
import 'package:petstagram/screens/signup_screen.dart';
import 'package:petstagram/utils/colors.dart';
import 'package:petstagram/utils/utils.dart';
import 'package:petstagram/widgets/text_field_input.dart';
import 'package:petstagram/responsive/mobile_screen_layout.dart';
import 'package:petstagram/responsive/web_screen_layout.dart';
import 'package:petstagram/responsive/responsive_layout_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // Dispose controllers
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // Login User
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (res == "success") {
      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      // Show error message
      showSnackBar(context, res);
    }
  }

  // Navigate to Sign Up Screen
  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Build UI
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: ListView(
            children: [
              SizedBox(height: 64),
              // Logo or App Name
              Center(
                child: Text(
                  'Petstagram',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 64),
              // Email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              // Password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(height: 24),
              // Login Button
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: primaryColor)
                      : Text('Log in'),
                ),
              ),
              SizedBox(height: 12),
              // Navigate to Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account? "),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: Text(
                        'Sign up.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
