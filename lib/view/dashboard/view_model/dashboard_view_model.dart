import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/model/akun.dart';

class DashboardViewModel extends ChangeNotifier {
  bool isLoading = false;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<Widget> pages = [];

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Akun? akunData;

  Future<void> getAkun({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('akun')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .limit(1)
          .get();

      Map<String, dynamic> userData = querySnapshot.docs.first.data();
      akunData = Akun(
        uid: userData['uid'],
        nama: userData['nama'],
        noHP: userData['noHP'],
        email: userData['email'],
        docId: userData['docId'],
        role: userData['role'],
      );

      notifyListeners();
    } on FirebaseException catch (e) {
      final snackbar = SnackBar(content: Text(e.message.toString()));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      throw Exception("GAGAL MENDAPATKAN AKUN ${e.message}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
