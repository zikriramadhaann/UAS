import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

// Halaman untuk lupa password
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Kunci form untuk validasi
  final _formKey = GlobalKey<FormState>();
  // Controller untuk input email
  final TextEditingController _emailController = TextEditingController();
  // Pesan untuk menampilkan notifikasi ke pengguna
  String _message = '';

  // Fungsi untuk mengirim email reset password
  Future<void> sendPasswordReset() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      setState(() {
        _message =
            'Link reset password telah dikirim ke ${_emailController.text}. Silakan cek email Anda.';
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _message = 'Email tidak terdaftar.';
        });
      } else {
        setState(() {
          _message = 'Terjadi kesalahan. Silakan coba lagi.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E092),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header dengan logo dan nama aplikasi
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
                    Image.asset('assets/images/logo.png', width: 200, height: 200),
                    const SizedBox(height: 10),
                    const Text(
                      'NutriCare',
                      style: TextStyle(
                        fontFamily: 'Shrikhand',
                        fontSize: 35,
                        color: Color(0xFFF3E092),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Form input email dan tombol kirim
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    // Input email
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Masukkan Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        final regex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!regex.hasMatch(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Tombol untuk mengirim link reset password
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendPasswordReset,
                        style: _buttonStyle(),
                        child: const Text('Kirim Link Reset Password'),
                      ),
                    ),
                    // Menampilkan pesan jika ada
                    if (_message.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 10),
                    // Navigasi kembali ke halaman login
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Kembali ke Login',
                        style: TextStyle(color: Color(0xFF3CAD75)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }
}