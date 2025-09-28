import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/Views/Widgets/label_with_textfield.dart';
import 'package:ecommerce/Views/Widgets/social_media_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login Account',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  LabelWithTextfield(
                    label: 'Email',
                    controller: emailController,
                    imgPath: 'assets/icons/email.png',
                    hintText: 'Enter Your Email',
                  ),
                  SizedBox(height: 20),
                  LabelWithTextfield(
                    label: 'Password',
                    controller: passwordController,
                    imgPath: 'assets/icons/password.png',
                    hintText: 'Enter Your Password',
                    suffixIcon: Icons.visibility,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Color(0XFFEDF8E9),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pushNamed(AppRoutes.homeRoute);
                        }
                      },
                      child: Text('Login', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.registerRoute);
                      },
                      child: Text(
                        'Don\'t Have An Account?, Register Now!',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SocialMediaButton(
                    text: 'LoginWithGoogle',
                    iconPath: 'assets/icons/google.png',
                    onTap: () {},
                  ),
                  SizedBox(height: 10),
                  SocialMediaButton(
                    text: 'LoginWithFacebook',
                    iconPath: 'assets/icons/facebook.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
