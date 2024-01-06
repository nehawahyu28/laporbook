import 'package:flutter/material.dart';
import 'package:lapor_book/components/button_widget.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/model/akun.dart';
import 'package:lapor_book/view/profile/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final Akun? akun;
  const ProfileScreen({super.key, this.akun});

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<ProfileViewModel>(context);

    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),

            //* NAMA
            Text(
              akun?.nama ?? "-",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),

            //* ROLE
            Text(
              akun?.role ?? "-",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            //* NOMER HP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: primaryColor),
                ), // Sudut border
              ),
              child: Text(
                akun?.noHP ?? "-",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            //* EMAIL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: primaryColor),
                ), // Sudut border
              ),
              child: Text(
                akun?.email ?? "-",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 24),

            //* BUTTON LOGOUT
            ButtonWidget(
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.amber,
              onPressed: () => controller.logOut(context: context),
            ),
          ],
        ),
      ),
    );
  }
}
