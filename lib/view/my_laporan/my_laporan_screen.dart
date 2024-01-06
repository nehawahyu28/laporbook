import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lapor_book/model/akun.dart';
import 'package:lapor_book/components/list_item.dart';
import 'package:lapor_book/helper/laporan_view_model.dart';

class MyLaporanScreen extends StatelessWidget {
  final Akun? akun;
  const MyLaporanScreen({super.key, this.akun});

  @override
  Widget build(BuildContext context) {
    Provider.of<LaporanViewModel>(
      context,
      listen: false,
    ).getMyTransaksi(context);

    return Consumer<LaporanViewModel>(
      builder: (context, controller, child) {
        return SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1 / 1.5,
            ),
            itemCount: controller.listMyLaporan.length,
            itemBuilder: (context, index) {
              var laporan = controller.listMyLaporan[index];

              return ListItem(
                laporan: laporan,
                akun: akun,
                isLaporanku: true,
              );
            },
          ),
        );
      },
    );
  }
}
