import 'package:flutter/material.dart';
import 'package:lapor_book/components/button_widget.dart';
import 'package:lapor_book/components/input_widget.dart';

import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/model/akun.dart';
import 'package:lapor_book/view/add_laporan/view_model/add_laporan_view_model.dart';
import 'package:provider/provider.dart';

class AddLaporanScreen extends StatelessWidget {
  const AddLaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final akun = ModalRoute.of(context)!.settings.arguments as Akun;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Tambah Laporan',
          style: headerStyle(
            level: 3,
            dark: false,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AddLaporanViewModel>(
        builder: (context, controller, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  //* INPUT JUDUL LAPORAN
                  InputWidget(
                    hintText: 'Judul Laporan',
                    controller: controller.judulController,
                    errorText: controller.errorMessage,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  //* PREVIEW GAMBAR
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: controller.imagePreview(),
                  ),
                  const SizedBox(height: 16),

                  //* DIALOG SUMBER GAMBAR / KAMERA / GALERI
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ButtonWidget(
                      label: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera_rounded),
                          Text(' Foto Pendukung')
                        ],
                      ),
                      backgroundColor: Colors.amber,
                      onPressed: () => controller.uploadDialog(context),
                    ),
                  ),
                  const SizedBox(height: 16),

                  //* PILIH INSTANSI
                  DropdownButtonFormField(
                    value: controller.selectedInstansi,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber,
                        ),
                      ),
                      hintText: 'Instansi',
                      isDense: true,
                    ),
                    items: controller.instansi.map((valueItems) {
                      return DropdownMenuItem(
                        value: valueItems,
                        child: Text(valueItems),
                      );
                    }).toList(),
                    onChanged: (newValueOnChanged) {
                      controller.setSelectedInstansi = newValueOnChanged;
                    },
                    onSaved: (newValueOnSaved) {
                      controller.setSelectedInstansi = newValueOnSaved;
                    },
                  ),
                  const SizedBox(height: 16),

                  //* INPUT DESKRIPSI
                  InputWidget(
                    hintText: 'Deskripsikan Semua Disini',
                    controller: controller.deskripsiController,
                    errorText: controller.errorMessage,
                    maxLines: 5,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 24),

                  //* BUTTON KIRIM LAPORAN
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
                            'Kirim Laporan',
                            style: TextStyle(color: Colors.white),
                          ),
                    backgroundColor: controller.isLoading
                        ? Colors.grey.shade300
                        : Colors.amber,
                    onPressed: () {
                      // fungsi dijalankan ketika loading false
                      if (controller.isLoading == false) {
                        controller.addTransaksi(akun, context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
