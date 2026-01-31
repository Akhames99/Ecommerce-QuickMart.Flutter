import 'package:ecommerce/Utils/app_colors.dart';
import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/auth_cubit/auth_cubit.dart';
import 'package:ecommerce/Views/Widgets/label_with_textfield.dart';
import 'package:ecommerce/Views/Widgets/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final cubit = BlocProvider.of<AuthCubit>(context);

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
                    child: BlocConsumer<AuthCubit, AuthState>(
                      bloc: cubit,
                      listenWhen: (previous, current) =>
                          current is AuthDone || current is AuthError,
                      listener: (context, state) {
                        if (state is AuthDone) {
                          Navigator.of(context).pushNamed(AppRoutes.homeRoute);
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)),
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is AuthLoading ||
                          current is AuthError ||
                          current is AuthDone,
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.bgcolor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Color(0XFFEDF8E9),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await cubit.loginWithEmailAndPassword(
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: Text('Login', style: TextStyle(fontSize: 20)),
                        );
                      },
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
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is GoogleAuthDone || current is GoogleAuthError,
                    listener: (context, state) {
                      if (state is GoogleAuthDone) {
                        Navigator.of(context).pushNamed(AppRoutes.homeRoute);
                      } else if (state is GoogleAuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is GoogleAuthenticating ||
                        current is GoogleAuthError ||
                        current is GoogleAuthDone,
                    builder: (context, state) {
                      if (state is GoogleAuthenticating) {
                        return SocialMediaButton(isLoading: true);
                      }
                      return SocialMediaButton(
                        text: 'LoginWithGoogle',
                        iconPath: 'assets/icons/google.png',
                        onTap: () async {
                          await cubit.authenticateWithGoogle();
                        },
                      );
                    },
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
