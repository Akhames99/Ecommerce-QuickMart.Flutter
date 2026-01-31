import 'package:ecommerce/Models/user_data.dart';
import 'package:ecommerce/Services/auth_services.dart';
import 'package:ecommerce/Services/firestore_services.dart';
import 'package:ecommerce/Utils/api_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices authServices = AuthServicesImpl();
  final firestoreServices = FirestoreServices.instance;

  Future<void> loginWithEmailAndPassword(String email, String passWord) async {
    emit(AuthLoading());
    try {
      final result = await authServices.loginWithEmailAndPassword(
        email,
        passWord,
      );
      if (result) {
        emit(AuthDone());
      } else {
        emit(AuthError(errorMessage: 'loginFailed'));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String passWord,
    String userName,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authServices.registerWithEmailAndPassword(
        email,
        passWord,
      );
      if (result) {
        await _saveUserDate(email, userName);
        emit(AuthDone());
      } else {
        emit(AuthError(errorMessage: 'registerFailed'));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> _saveUserDate(String email, String userName) async {
    final currentUser = authServices.currentUser();
    final userData = UserData(
      id: currentUser!.uid,
      userName: userName,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
    );
    await firestoreServices.setData(
      path: ApiPaths.users(userData.id),
      data: userData.toMap(),
    );
  }

  void checkAuth() {
    final user = authServices.currentUser();
    if (user != null) {
      emit(const AuthDone());
    }
  }

  Future<void> logOut() async {
    emit(const AuthLoggingOut());
    try {
      await authServices.logOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthLoggingError(e.toString()));
    }
  }

  Future<void> authenticateWithGoogle() async {
    emit(GoogleAuthenticating());
    try {
      final result = await authServices.authenticateWithGoogle();
      if (result) {
        emit(AuthDone());
      } else {
        emit(AuthError(errorMessage: 'SomeThing Went Wrong'));
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }
}
