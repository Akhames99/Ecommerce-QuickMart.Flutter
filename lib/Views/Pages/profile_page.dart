import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);

    return Center(
      child: BlocConsumer<AuthCubit, AuthState>(
        bloc: cubit,
        listenWhen: (previous, current) =>
            current is AuthLoggedOut || current is AuthLoggingError,
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(AppRoutes.loginRoute, (route) => false);
          } else if (state is AuthLoggingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (previous, current) => current is AuthLoggingOut,
        builder: (context, state) {
          if (state is AuthLoggingOut) {
            return SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              await cubit.logOut();
            },
            child: Text('LogOut', style: TextStyle(fontSize: 20)),
          );
        },
      ),
    );
  }
}
