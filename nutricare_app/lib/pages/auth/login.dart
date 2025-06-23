import 'package:flutter/material.dart';
import 'register.dart';
import 'forgot_password.dart';
import 'package:nutricare_app/pages/home.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Halaman Login Utama
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State untuk LoginPage
class _LoginPageState extends State<LoginPage> {
  // Controller untuk input email
  final TextEditingController _emailController = TextEditingController();
  // Controller untuk input kata sandi
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk proses login
  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
  
    // Validasi input email dan kata sandi
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Email dan kata sandi wajib diisi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      try {
        // Proses autentikasi dengan Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Navigasi ke halaman utama jika login berhasil
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        // Penanganan error autentikasi
        String message = 'Pengguna tidak terdaftar.';
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          message = 'Email atau kata sandi salah.';
        }
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Penanganan error umum
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text('Terjadi kesalahan saat mencoba login: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E092),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian header dengan logo dan judul aplikasi
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF3CAD75),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'NutriCare',
                    style: TextStyle(
                      fontFamily: 'Shrikhand',
                      fontSize: 30,
                      color: Color(0xFFF3E092),
                    ),
                  ),
                ],
              ),
            ),
            // Form login
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input email
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                  ),
                  const SizedBox(height: 12),
                  // Input kata sandi
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Kata Sandi'),
                  ),
                  // Tombol lupa kata sandi
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lupa kata sandi?',
                        style: TextStyle(
                          color: Color(0xFF3CAD75),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tombol daftar dan masuk
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          style: _buttonStyle(),
                          child: const Text('Daftar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _login,
                          style: _buttonStyle(),
                          child: const Text('Masuk'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dekorasi untuk input field
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black38, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3CAD75), width: 2),
      ),
    );
  }

  // Style untuk tombol
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3CAD75),
      foregroundColor: Colors.white,
      shadowColor: Colors.black45,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }
}