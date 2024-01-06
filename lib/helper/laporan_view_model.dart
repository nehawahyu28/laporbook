import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/model/laporan.dart';
import 'package:lapor_book/routes/routes_navigation.dart';

class LaporanViewModel extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  String emptyImage =
      'https://www.kalderanews.com/wp-content/uploads/2022/01/Sultan-Gustaf-AL-Ghozali-atau-yang-dikenal-Ghozali-Everyday-mahasiswa-Udinus.-Dok.-Udinus-600x381.jpg';

  List<Laporan> listAllLaporan = [];
  List<Laporan> listMyLaporan = [];

  Future<void> getAllTransaksi(BuildContext context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('laporan').get();

      listAllLaporan.clear();
      for (var documents in querySnapshot.docs) {
        List<dynamic>? komentarData = documents.data()['komentar'];

        List<Komentar>? listKomentar = komentarData?.map((map) {
          return Komentar(
            nama: map['nama'],
            isi: map['isi'],
          );
        }).toList();

        listAllLaporan.add(
          Laporan(
            uid: documents.data()['uid'],
            docId: documents.data()['docId'],
            judul: documents.data()['judul'],
            instansi: documents.data()['instansi'],
            deskripsi: documents.data()['deskripsi'],
            nama: documents.data()['nama'],
            status: documents.data()['status'],
            gambar: documents.data()['gambar'],
            tanggal: documents['tanggal'].toDate(),
            maps: documents.data()['maps'],
            komentar: listKomentar,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mendapatkan Laporan'),
          ),
        );
      }
      throw Exception('GAGAL MENDAPATKAN LAPORAN');
    }
  }

  Future<void> getMyTransaksi(BuildContext context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('laporan')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();

      listMyLaporan.clear();
      for (var documents in querySnapshot.docs) {
        List<dynamic>? komentarData = documents.data()['komentar'];

        List<Komentar>? listKomentar = komentarData?.map((map) {
          return Komentar(
            nama: map['nama'],
            isi: map['isi'],
          );
        }).toList();

        listMyLaporan.add(
          Laporan(
            uid: documents.data()['uid'],
            docId: documents.data()['docId'],
            judul: documents.data()['judul'],
            instansi: documents.data()['instansi'],
            deskripsi: documents.data()['deskripsi'],
            nama: documents.data()['nama'],
            status: documents.data()['status'],
            gambar: documents.data()['gambar'],
            tanggal: documents['tanggal'].toDate(),
            maps: documents.data()['maps'],
            komentar: listKomentar,
          ),
        );
      }
      notifyListeners();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mendapatkan Laporan'),
          ),
        );
      }
      throw Exception('GAGAL MENDAPATKAN LAPORAN ${e.message}');
    }
  }

  void deleteLaporan(Laporan laporan, BuildContext context) async {
    try {
      await firestore.collection('laporan').doc(laporan.docId).delete();

      if (laporan.gambar != '') {
        await storage.refFromURL(laporan.gambar!).delete();
      }
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesNavigation.dashboard,
          (route) => false,
        );
      }
    } catch (e) {
      throw Exception('GAGAL MENGHAPUS LAPORAN $e');
    }
  }

  void openDeleteDialog(
    bool isLaporanku,
    BuildContext context,
    Laporan laporan,
  ) {
    if (isLaporanku == true) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${laporan.judul}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  deleteLaporan(laporan, context);
                },
                child: const Text('Hapus'),
              ),
            ],
          );
        },
      );
    }
  }
}
