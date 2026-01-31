import 'package:ecommerce/Utils/app_router.dart';
import 'package:ecommerce/Utils/app_routes.dart';
import 'package:ecommerce/View_Models/auth_cubit/auth_cubit.dart';
import 'package:ecommerce/View_Models/favorite_cubit/favorite_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await handleNotifications();
  runApp(const MyApp());
}

Future<void> handleNotifications() async {
  // Taking Permission
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // Handling Foreground Messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
        'Message also contained a notification: ${message.notification}',
      );
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) {
            final cubit = AuthCubit();
            cubit.checkAuth();
            return cubit;
          },
        ),
        BlocProvider<FavoriteCubit>(
          // FavoriteCubit now initializes favorites automatically in its constructor
          // No need to call getFavoriteProducts() here
          create: (context) => FavoriteCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authCubit = BlocProvider.of<AuthCubit>(context);
          return BlocBuilder<AuthCubit, AuthState>(
            bloc: authCubit,
            buildWhen: (previous, current) =>
                current is AuthDone || current is AuthInitial,
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'E-Commerce App',
                theme: ThemeData(
                  fontFamily: "Coolvetica",
                  primaryColor: const Color(0xFF005A32),
                  scaffoldBackgroundColor: Colors.white,
                ),
                initialRoute: state is AuthDone
                    ? AppRoutes.homeRoute
                    : AppRoutes.loginRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
