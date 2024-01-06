import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/routes/routes_navigation.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool _visiblePassword = true;
  bool get visiblePassword => _visiblePassword;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  String? errorMessage;

  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> login({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      bool isValid = valueValidator(email, password);

      if (isValid) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        clear(); // untuk mengosongkan input

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesNavigation.dashboard,
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Gagal'),
          ),
        );
      }
      throw Exception("GAGAL MELAKUKAN LOGIN ${e.message}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool valueValidator(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = 'Input Tidak Boleh Kosong';
      return false;
    } else {
      errorMessage = null;
      return true;
    }
  }

  void clear() {
    _emailController.clear();
    _passwordController.clear();
    _emailController.text = '';
    _passwordController.text = '';
    notifyListeners();
  }

  void isVisiblePassword() {
    _visiblePassword = !_visiblePassword;
    notifyListeners();
  }
}
