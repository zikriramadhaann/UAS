import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:async';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Tambahkan list email terdaftar di sini
  final List<String> emailTerdaftar = [
    '1@email.com',
    '2@email.com',
    '3@email.com',
  ];

  bool isOTPSent = false;
  bool isOTPVerified = false;
  String _message = '';
  int _secondsRemaining = 0;
  Timer? _timer;

  // Modifikasi fungsi sendOTP
  void sendOTP() {
    if (!_formKey.currentState!.validate()) return;

    if (!emailTerdaftar.contains(_emailController.text)) {
      setState(() {
        _message = 'Email tidak terdaftar. Silakan daftar terlebih dahulu.';
      });
      return;
    }

    setState(() {
      isOTPSent = true;
      _message = 'Kode OTP telah dikirim ke ${_emailController.text}';
    });
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void verifyOTP() {
    if (_otpController.text == '123456') {
      setState(() {
        isOTPVerified = true;
        _message = 'OTP berhasil diverifikasi.';
      });
    } else {
      setState(() {
        _message = 'OTP salah. Silakan coba lagi.';
      });
    }
  }

  void saveNewPassword() {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _message = 'Kata sandi tidak cocok.');
      return;
    }

    // panggil API untuk update password di server

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diubah!')),
    );
    // Otomatis kembali ke login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              // Header
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    // Email input
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

                    // Tombol kirim OTP
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendOTP,
                        style: _buttonStyle(),
                        child: const Text('Kirim Kode OTP'),
                      ),
                    ),

                    // Input OTP setelah dikirim
                    if (isOTPSent) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _otpController,
                        decoration: _inputDecoration('Masukkan Kode OTP'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: verifyOTP,
                          style: _buttonStyle(),
                          child: const Text('Verifikasi OTP'),
                        ),
                      ),
                    ],

                    // Form ganti password setelah OTP terverifikasi
                    if (isOTPVerified) ...[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: _inputDecoration('Kata Sandi Baru'),
                        obscureText: true,
                        validator: (value) {
                          if (isOTPVerified &&
                              (value == null || value.isEmpty)) {
                            return 'Kata sandi baru tidak boleh kosong';
                          }
                          if (value != null && value.length < 6) {
                            return 'Minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: _inputDecoration('Konfirmasi Kata Sandi'),
                        obscureText: true,
                        validator: (value) {
                          if (isOTPVerified &&
                              (value == null || value.isEmpty)) {
                            return 'Konfirmasi kata sandi tidak boleh kosong';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Kata sandi tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: saveNewPassword,
                          style: _buttonStyle(),
                          child: const Text('Simpan Kata Sandi Baru'),
                        ),
                      ),
                    ],

                    // Pesan kesalahan / info
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

                    // Kembali ke login
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
