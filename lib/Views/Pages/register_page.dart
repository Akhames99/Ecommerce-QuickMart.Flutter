import 'package:ecommerce/Utils/app_colors.dart';
import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/auth_cubit/auth_cubit.dart';
import 'package:ecommerce/Views/Widgets/label_with_textfield.dart';
import 'package:ecommerce/Views/Widgets/social_media_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userController = TextEditingController();
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
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  LabelWithTextfield(
                    label: 'UserName',
                    controller: userController,
                    imgPath: 'assets/icons/person.png',
                    hintText: 'Enter Your User Name',
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
                          current is AuthDone ||
                          current is AuthLoading ||
                          current is AuthError,
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {},
                            child: Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.bgcolor,
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
                              await cubit.registerWithEmailAndPassword(
                                emailController.text,
                                passwordController.text,
                                userController.text,
                              );
                            }
                          },
                          child: Text(
                            'Create Account',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.loginRoute);
                      },
                      child: Text(
                        'Do You Have An Account? , Login Now!',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SocialMediaButton(
                    text: 'SignUpWithGoogle',
                    iconPath: 'assets/icons/google.png',
                    onTap: () {},
                  ),
                  SizedBox(height: 10),
                  SocialMediaButton(
                    text: 'SignUpWithFacebook',
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
