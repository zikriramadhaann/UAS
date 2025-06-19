import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahJadwalPage extends StatefulWidget {
  const TambahJadwalPage({super.key});

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  String selectedJenis = 'Bantuan Anak Sekolah';
  final List<String> jenisBantuan = [
    'Bantuan Anak Sekolah',
    'Bantuan Balita',
    'Bantuan Ibu Hamil',
  ];

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tanggalController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        waktuController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF3CAD75),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 50),
                const SizedBox(width: 1),
                const Text(
                  'NutriCare',
                  style: TextStyle(
                    fontFamily: 'Shrikhand',
                    fontSize: 28,
                    color: Color(0xFFF3E092),
                  ),
                ),
              ],
            ),
          ),

          // Body Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF3CAD75), width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tambah Jadwal Bantuan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Silakan isi formulir berikut dengan benar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // Dropdown Jenis Bantuan
                    _buildLabel("Jenis Bantuan"),
                    DropdownButtonFormField<String>(
                      value: selectedJenis,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF3CAD75),
                      ),
                      decoration: _inputDecoration(
                        hintText: 'Pilih jenis bantuan',
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      items: _buildDropdownItems(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedJenis = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 5),

                    // Tanggal
                    _buildLabel("Tanggal"),
                    TextFormField(
                      controller: tanggalController,
                      readOnly: true,
                      onTap: _selectDate,
                      decoration: _inputDecoration(hintText: 'dd/mm/yyyy'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),

                    // Waktu
                    _buildLabel("Waktu"),
                    TextFormField(
                      controller: waktuController,
                      readOnly: true,
                      onTap: _selectTime,
                      decoration: _inputDecoration(hintText: '08:00'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),

                    // Lokasi Pembagian
                    _buildLabel("Lokasi Pembagian"),
                    TextFormField(
                      controller: lokasiController,
                      decoration: _inputDecoration(
                        hintText: 'Contoh: Aula sekolah',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lokasi pembagian wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),

                    // Catatan
                    _buildLabel("Catatan"),
                    TextFormField(
                      controller: catatanController,
                      minLines: 3, // minimal 3 baris
                      maxLines:
                          null, // tidak dibatasi, akan bertambah sesuai isi
                      decoration: _inputDecoration(
                        hintText:
                            'Contoh: Perlu koordinasi dengan kader RT ',
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Jadwal berhasil disimpan'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3CAD75),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'SIMPAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navbar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF3CAD75), width: 2)),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: const Color(0xFF3CAD75),
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            onTap: (idx) {
              switch (idx) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/formulir');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/histori');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/profil');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Formulir',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Histori',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Label helper
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF3CAD75),
        ),
      ),
    );
  }

  // Input decoration helper
  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFF3CAD75), width: 2),
      ),
    );
  }

  // Dropdown items tanpa padding
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return jenisBantuan.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      );
    }).toList();
  }
}
