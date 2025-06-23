import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Halaman pendaftaran pengguna
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Kunci global untuk form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap field input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _kodePetugasController = TextEditingController();

  // Kode petugas yang valid
  static const String _kodePetugasValid = 'PETUGAS123';

  // Menyimpan data pengguna ke Firestore
  Future<void> _simpanKeFirestore(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': 'petugas lapangan',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E092),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _inputField(_nameController, 'Nama Lengkap'),
                    const SizedBox(height: 10),
                    _inputField(
                      _emailController,
                      'Email',
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    _inputField(
                      _passwordController,
                      'Kata Sandi',
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    _inputField(
                      _confirmPasswordController,
                      'Konfirmasi Kata Sandi',
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    _inputField(_kodePetugasController, 'Kode Petugas'),
                    const SizedBox(height: 20),
                    _daftarButton(context),
                    const SizedBox(height: 10),
                    _backButton(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget header/logo aplikasi
  Widget _header() {
    return Container(
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
          Image.asset('assets/images/logo.png', width: 250, height: 250),
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
    );
  }

  // Widget field input dengan validasi
  Widget _inputField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      decoration: _inputDecoration(label),
      validator: (value) {
        // Validasi jika field kosong
        if (value == null || value.isEmpty) return '$label wajib diisi';
        // Validasi format email
        if (label == 'Email' &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Format email tidak valid';
        }
        // Validasi konfirmasi kata sandi
        if (label == 'Konfirmasi Kata Sandi' &&
            value != _passwordController.text) {
          return 'Konfirmasi sandi tidak cocok';
        }
        // Validasi kode petugas
        if (label == 'Kode Petugas' && value != _kodePetugasValid) {
          return 'Kode petugas salah';
        }
        return null;
      },
    );
  }

  // Tombol daftar
  Widget _daftarButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Validasi form sebelum daftar
          if (_formKey.currentState!.validate()) {
            try {
              // Membuat akun baru dengan Firebase Auth
              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );
              // Simpan data ke Firestore
              await _simpanKeFirestore(userCredential.user!.uid);

              // Tampilkan pesan sukses
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pendaftaran berhasil!')),
              );
              await Future.delayed(const Duration(seconds: 1));
              // Navigasi ke halaman login
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/login');
            } on FirebaseAuthException catch (e) {
              // Tangani error Firebase Auth
              String message = 'Gagal daftar: ${e.message}';
              if (e.code == 'email-already-in-use') {
                message = 'Email sudah terdaftar.';
              }
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            } catch (e) {
              // Tangani error lain
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Gagal daftar: $e')));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3CAD75),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Daftar'),
      ),
    );
  }

  // Tombol kembali ke halaman login
  Widget _backButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3CAD75),
          side: const BorderSide(color: Color(0xFF3CAD75)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Kembali ke Masuk'),
      ),
    );
  }

  // Dekorasi untuk field input
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black38, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF3CAD75), width: 2),
      ),
    );
  }
}