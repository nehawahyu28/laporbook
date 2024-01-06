import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/routes/routes_navigation.dart';

import 'package:lapor_book/view/profile/profile_screen.dart';
import 'package:lapor_book/view/my_laporan/my_laporan_screen.dart';
import 'package:lapor_book/view/all_laporan/all_laporan_screen.dart';

import 'package:lapor_book/view/dashboard/view_model/dashboard_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DashboardViewModel>(
      context,
      listen: false,
    ).getAkun(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, controller, child) {
        controller.pages = [
          AllLaporanScreen(akun: controller.akunData),
          MyLaporanScreen(akun: controller.akunData),
          ProfileScreen(akun: controller.akunData),
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text('Lapor Book', style: headerStyle(level: 2)),
            centerTitle: true,
          ),
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.pages.elementAt(controller.selectedIndex),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: const Icon(Icons.add, size: 35),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesNavigation.addLaporan,
                arguments: controller.akunData,
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: primaryColor,
            currentIndex: controller.selectedIndex,
            onTap: (index) => controller.onItemTapped(index),
            selectedItemColor: Colors.white,
            selectedFontSize: 16,
            unselectedItemColor: Colors.grey[800],
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Semua',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                label: 'Laporan Saya',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
