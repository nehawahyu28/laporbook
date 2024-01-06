import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lapor_book/model/akun.dart';
import 'package:lapor_book/model/laporan.dart';
import 'package:lapor_book/routes/routes_navigation.dart';
import 'package:lapor_book/helper/laporan_view_model.dart';

class ListItem extends StatelessWidget {
  final Laporan laporan;
  final Akun? akun;
  final bool isLaporanku;

  const ListItem({
    super.key,
    required this.laporan,
    required this.akun,
    required this.isLaporanku,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LaporanViewModel>(
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            RoutesNavigation.detailLaporan,
            arguments: {
              'laporan': laporan,
              'akun': akun,
            },
          ),
          onLongPress: () => controller.openDeleteDialog(
            isLaporanku,
            context,
            laporan,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //* GAMBAR LAPORAN
                if (laporan.gambar?.isNotEmpty == true) ...[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        laporan.gambar ?? '-',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        controller.emptyImage,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],

                const Divider(
                  color: Colors.grey,
                ),
                //* JUDUL LAPORAN
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      laporan.judul,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),

                //* STATUS & TANGGAL
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            laporan.status,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            DateFormat('MM/dd/yyyy').format(
                              laporan.tanggal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
