/// package
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lapor_book/helper/laporan_view_model.dart';
import 'package:provider/provider.dart';
import 'package:lapor_book/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

/// controller/providers
import 'package:lapor_book/view/login/view_model/login_view_model.dart';
import 'package:lapor_book/view/splash/view_model/splash_view_model.dart';
import 'package:lapor_book/view/profile/view_model/profile_view_model.dart';
import 'package:lapor_book/view/register/view_model/register_view_model.dart';
import 'package:lapor_book/view/dashboard/view_model/dashboard_view_model.dart';
import 'package:lapor_book/view/add_laporan/view_model/add_laporan_view_model.dart';
import 'package:lapor_book/view/detail_laporan/view_model/detail_laporan_view_model.dart';

/// screen
import 'package:lapor_book/view/login/login_screen.dart';
import 'package:lapor_book/view/splash/splash_screen.dart';
import 'package:lapor_book/view/register/register_screen.dart';
import 'package:lapor_book/view/dashboard/dashboard_screen.dart';
import 'package:lapor_book/view/add_laporan/add_laporan_screen.dart';
import 'package:lapor_book/view/detail_laporan/detail_laporan_screen.dart';

/// constant -> routes navigation
import 'package:lapor_book/routes/routes_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null).then(
    (value) => runApp(const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => AddLaporanViewModel()),
        ChangeNotifierProvider(create: (_) => DetailLaporanViewModel()),
      ],
      child: MaterialApp(
        title: 'Lapor Book',
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesNavigation.init,
        routes: {
          RoutesNavigation.init: (_) => const SplashScreen(),
          RoutesNavigation.login: (_) => const LoginScreen(),
          RoutesNavigation.register: (_) => const RegisterScreen(),
          RoutesNavigation.dashboard: (_) => const DashboardScreen(),
          RoutesNavigation.addLaporan: (_) => const AddLaporanScreen(),
          RoutesNavigation.detailLaporan: (_) => const DetailLaporanScreen(),
        },
      ),
    );
  }
}
