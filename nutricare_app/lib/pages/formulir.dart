import 'package:flutter/material.dart';

void main() => runApp(const NutriCareApp());

class NutriCareApp extends StatelessWidget {
  const NutriCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriCare',
      theme: ThemeData(
        primarySwatch: Colors.green,
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF3CAD75);
            }
            return const Color(0xFFBDBDBD);
          }),
        ),
      ),
      home: const FormulirGabungan(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const DummyPage(title: 'Beranda'),
        '/formulir': (context) => const FormulirGabungan(),
        '/profil': (context) => const DummyPage(title: 'Profil'),
        '/histori': (context) => const DummyPage(title: 'Histori'),
      },
    );
  }
}

class FormulirGabungan extends StatefulWidget {
  const FormulirGabungan({super.key});

  @override
  State<FormulirGabungan> createState() => _FormulirGabunganState();
}

class _FormulirGabunganState extends State<FormulirGabungan> {
  final _formKey = GlobalKey<FormState>();

  String selectedForm = 'Bantuan Anak Sekolah';
  final List<String> daftarFormulir = [
    'Bantuan Anak Sekolah',
    'Bantuan Balita',
    'Bantuan Ibu Hamil',
  ];

  // Controller Anak Sekolah
  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController nomorUrutAbsenCtrl = TextEditingController();
  String? selectedGender;
  final TextEditingController usiaCtrl = TextEditingController();
  final TextEditingController asalSekolahCtrl = TextEditingController();
  final TextEditingController kelasCtrl = TextEditingController();
  final TextEditingController waliKelasCtrl = TextEditingController();
  final TextEditingController ortuAnakCtrl = TextEditingController();

  // Controller Balita
  final TextEditingController usiaBlnCtrl = TextEditingController();
  final TextEditingController beratCtrl = TextEditingController();
  final TextEditingController tinggiCtrl = TextEditingController();
  final TextEditingController alergiCtrl = TextEditingController();
  final TextEditingController ortuCtrl = TextEditingController();

  // Controller Ibu Hamil
  final TextEditingController nikCtrl = TextEditingController();
  final TextEditingController _usiaIbuHamilCtrl = TextEditingController();
  final TextEditingController usiaHamilCtrl = TextEditingController();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController fasilitasCtrl = TextEditingController();
  final TextEditingController telpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
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
                  children: [
                    const Text(
                      'Formulir Bantuan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedForm,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF3CAD75),
                      ),
                      decoration: _inputDecoration(
                        hintText: 'Pilih jenis formulir',
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      items:
                          daftarFormulir.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedForm = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (selectedForm == 'Bantuan Anak Sekolah') ...[
                            _buildTextField(namaCtrl, 'Nama Lengkap'),
                            _buildRadioGroup(
                              'Gender',
                              ['Laki-laki', 'Perempuan'],
                              selectedGender,
                              (value) {
                                setState(() => selectedGender = value);
                              },
                            ),
                            _buildTextField(
                              nomorUrutAbsenCtrl,
                              'Nomor Urut Absen',
                            ),
                            _buildTextField(kelasCtrl, 'Kelas'),
                            _buildTextField(asalSekolahCtrl, 'Asal Sekolah'),
                            _buildTextField(waliKelasCtrl, 'Nama Wali Kelas'),
                            _buildTextField(ortuAnakCtrl, 'Nama Orang Tua'),
                          ] else if (selectedForm == 'Bantuan Balita') ...[
                            _buildTextField(namaCtrl, 'Nama Lengkap'),
                            _buildRadioGroup(
                              'Gender',
                              ['Laki-laki', 'Perempuan'],
                              selectedGender,
                              (value) {
                                setState(() => selectedGender = value);
                              },
                            ),
                            _buildTextField(usiaBlnCtrl, 'Usia (bulan)'),
                            _buildTextField(beratCtrl, 'Berat Badan (kg)'),
                            _buildTextField(tinggiCtrl, 'Tinggi Badan (cm)'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: TextFormField(
                                controller: alergiCtrl,
                                decoration: _inputDecoration(
                                  hintText: 'Alergi (jika ada)',
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            _buildTextField(ortuCtrl, 'Nama Orang Tua'),
                          ] else if (selectedForm == 'Bantuan Ibu Hamil') ...[
                            _buildTextField(namaCtrl, 'Nama Lengkap'),
                            _buildTextField(nikCtrl, 'NIK'),
                            _buildTextField(
                              _usiaIbuHamilCtrl,
                              'Usia Ibu Hamil (tahun)', // Label baru
                            ),
                            _buildTextField(
                              usiaHamilCtrl,
                              'Usia Kehamilan (minggu)',
                            ),
                            _buildTextField(
                              alamatCtrl,
                              'Alamat Tempat Tinggal',
                            ),
                            _buildTextField(
                              fasilitasCtrl,
                              'Faskes yang Dikunjungi',
                            ),
                            _buildTextField(telpCtrl, 'No. Telepon'),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data formulir berhasil disimpan'),
                            ),
                          );
                        }
                        namaCtrl.clear();
                        usiaCtrl.clear();
                        asalSekolahCtrl.clear();
                        kelasCtrl.clear();
                        nomorUrutAbsenCtrl.clear();
                        selectedGender = null;
                        ortuCtrl.clear();
                        waliKelasCtrl.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3CAD75),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
            currentIndex: 1,
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

  Widget _buildTextField(TextEditingController controller, String label) {
    bool isAngka =
        label.toLowerCase().contains('usia') ||
        label.toLowerCase().contains('kelas') &&
            !label.toLowerCase().contains('wali') || // Perbaikan di sini
        label.toLowerCase().contains('nomor urut absen') ||
        label.toLowerCase().contains('berat') ||
        label.toLowerCase().contains('tinggi') ||
        label.toLowerCase().contains('no') ||
        label.toLowerCase().contains('nik');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(hintText: label),
        keyboardType: isAngka ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRadioGroup(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Row(
            children:
                options.map((option) {
                  return Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: selectedValue,
                          onChanged: onChanged,
                        ),
                        Text(option),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

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
}

class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF3CAD75),
      ),
      body: Center(child: Text('Halaman $title')),
    );
  }
}
