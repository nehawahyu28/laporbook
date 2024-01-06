import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/button_widget.dart';
import 'package:lapor_book/components/input_widget.dart';

import 'package:lapor_book/view/login/view_model/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginViewModel>(
        builder: (context, controller, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    //* TITLE LOGIN
                    Text(
                      'Login',
                      style: headerStyle(level: 1),
                    ),
                    const SizedBox(height: 24),

                    //* INPUT EMAIL
                    InputWidget(
                      hintText: 'Email',
                      controller: controller.emailController,
                      errorText: controller.errorMessage,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),

                    //* INPUT PASSWORD
                    InputWidget(
                      hintText: 'Password',
                      controller: controller.passwordController,
                      errorText: controller.errorMessage,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: controller.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: () => controller.isVisiblePassword(),
                        color: Colors.grey,
                        icon: controller.visiblePassword
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),

                    //* LOGIN BUTTON
                    ButtonWidget(
                      label: controller.isLoading
                          ? const Center(
                              child: Flexible(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                      backgroundColor: controller.isLoading
                          ? Colors.grey.shade300
                          : Colors.amber,
                      onPressed: () {
                        // fungsi dijalankan ketika loading false
                        if (controller.isLoading == false) {
                          controller.login(context: context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
