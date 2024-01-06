import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor_book/model/akun.dart';
import 'package:lapor_book/routes/routes_navigation.dart';

class AddLaporanViewModel extends ChangeNotifier {
  bool isLoading = false;

  final _judulController = TextEditingController();
  TextEditingController get judulController => _judulController;
  final _deskripsiController = TextEditingController();
  TextEditingController get deskripsiController => _deskripsiController;

  String? errorMessage;

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  ImagePicker picker = ImagePicker();
  XFile? file;

  final List<String> instansi = [
    "Pembangunan",
    "Jalan",
    "Pendidikan",
  ];
  List<String> dataStatus = ['Posted', 'Proses', 'Selesai'];
  List<Color> warnaStatus = [Colors.amber, Colors.red, Colors.green];

  String? _selectedInstansi;
  String? get selectedInstansi => _selectedInstansi;
  set setSelectedInstansi(String? newBank) {
    _selectedInstansi = newBank;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _judulController.dispose();
    _deskripsiController.dispose();
  }

  bool valueValidator(String judul, String deskripsi) {
    if (judul.isEmpty || deskripsi.isEmpty) {
      errorMessage = 'Input Tidak Boleh Kosong';
      return false;
    } else {
      errorMessage = null;
      return true;
    }
  }

  void clear() {
    _judulController.clear();
    _deskripsiController.clear();
    _judulController.text = '';
    _deskripsiController.text = '';
    _selectedInstansi = '';
    _selectedInstansi = null;
    file = null;
    notifyListeners();
  }

  Image imagePreview() {
    if (file == null) {
      return Image.asset(
        'assets/upload.png',
        width: 180,
        height: 180,
      );
    } else {
      return Image.file(
        File(file!.path),
        width: 180,
        height: 180,
      );
    }
  }

  Future<dynamic> uploadDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih sumber '),
          actions: [
            TextButton(
              onPressed: () async {
                XFile? upload = await picker.pickImage(
                  source: ImageSource.camera,
                );

                file = upload;
                notifyListeners();

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
            TextButton(
              onPressed: () async {
                XFile? upload =
                    await picker.pickImage(source: ImageSource.gallery);

                file = upload;
                notifyListeners();

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(Icons.photo_library),
            ),
          ],
        );
      },
    );
  }

  Future<Position> getCurrentLocation() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference dirUpload = storage.ref().child(
            'upload/${auth.currentUser!.uid}',
          );
      Reference storedDir = dirUpload.child(uniqueFilename);

      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  void addTransaksi(Akun akun, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      CollectionReference laporanCollection = firestore.collection('laporan');

      // Convert DateTime to Firestore Timestamp
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());

      String url = await uploadImage();

      String currentLocation = await getCurrentLocation().then((value) {
        return '${value.latitude},${value.longitude}';
      });

      String maps = 'https://www.google.com/maps/place/$currentLocation';
      final id = laporanCollection.doc().id;

      String judul = _judulController.text;
      String deskripsi = _deskripsiController.text;

      bool isValid = valueValidator(judul, deskripsi);

      if (isValid && _selectedInstansi?.isNotEmpty == true && file != null) {
        await laporanCollection.doc(id).set({
          'uid': auth.currentUser!.uid,
          'docId': id,
          'judul': judul,
          'instansi': _selectedInstansi,
          'deskripsi': deskripsi,
          'gambar': url,
          'nama': akun.nama,
          'status': 'Posted', // posted, process, done
          'tanggal': timestamp,
          'maps': maps,
        }).catchError((e) {
          throw e;
        });

        clear();

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesNavigation.dashboard,
            (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil membuat laporan'),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Silahkan dilengkapi terlebih dahulu Formnya'),
            ),
          );
        }
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal Mengupload Laporan'),
          ),
        );
        throw Exception('GAGAL MENGUPLOAD LAPORAN ${e.message}');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
