import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/auth/splash_screen.dart';
import 'pages/auth/login.dart';
import 'pages/auth/register.dart';
import 'pages/auth/forgot_password.dart';
import 'pages/home.dart';
import 'pages/histori.dart';
import 'pages/profil.dart';
import 'pages/edit_profil.dart';
import 'pages/tambah_jadwal.dart';
import 'pages/rekap_bulanan.dart';
import 'pages/formulir.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⬇️ Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const NutriCareApp());
}

class NutriCareApp extends StatelessWidget {
  const NutriCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFFCFBFB),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF3CAD75)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3CAD75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        '/histori': (context) => HistoriPage(),
        '/profil': (context) => const ProfilPage(),
        '/edit_profil': (context) => const EditProfilPage(),
        '/tambah_jadwal': (context) => const TambahJadwalPage(),
        '/rekap_bulanan': (context) => const RekapBulananPage(),
        '/formulir': (context) => const FormulirGabungan(),
      },
    );
  }
}
