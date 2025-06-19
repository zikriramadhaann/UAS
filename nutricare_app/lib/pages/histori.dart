import 'package:flutter/material.dart';

class HistoriPage extends StatefulWidget {
  const HistoriPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoriPageState createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  late String selectedFilter;

  final List<String> filters = [
    'Bantuan Anak Sekolah',
    'Bantuan Balita',
    'Bantuan Ibu Hamil',
  ];

  List<Map<String, String>> historiData = [
    {
      'jenis': 'Bantuan Anak Sekolah',
      'nama': 'Zikri Ramadhan',
      'gender': 'Laki-laki',
      'absen': '07',
      'kelas': 'Kelas 12',
      'sekolah': 'SMKN 1 Kota Solok',
      'wali': 'Ibu Fitriani',
      'ortu': 'Rina Marlina',
      'tanggal': '20 April 2025',
    },
    {
      'jenis': 'Bantuan Balita',
      'nama': 'Aqila Zahra',
      'gender': 'Perempuan',
      'usia': '24',
      'berat': '12',
      'tinggi': '85',
      'alergi': 'Tidak Ada',
      'ortu': 'Rina Marlina',
      'tanggal': '12 Mei 2025',
    },
    {
      'jenis': 'Bantuan Ibu Hamil',
      'nama': 'Sari Dewi',
      'nik': '1234567890123456',
      'usiaIbu': '32',
      'usiaKehamilan': '28',
      'alamat': 'Jl. Merpati No. 10',
      'faskes': 'Puskesmas Harapan',
      'telp': '081234567890',
      'tanggal': '30 Mei 2025',
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    final filteredData =
        historiData.where((item) => item['jenis'] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6E29C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF3CAD75), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFilter,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedFilter = newValue!;
                          });
                        },
                        dropdownColor: const Color(0xFFFFF8DC),
                        borderRadius: BorderRadius.circular(10),
                        items:
                            filters.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFF3CAD75),
                                width: 1.5,
                              ),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: _buildCardContent(item),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
          padding: const EdgeInsets.only(bottom: 4),
          child: BottomNavigationBar(
            currentIndex: 2,
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

  Widget _buildCardContent(Map<String, String> item) {
    List<Widget> children = [];

    void addField(String label, String? value) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 170,
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 10,
                child: Text(":", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Text(value ?? '-')),
            ],
          ),
        ),
      );
    }

    switch (item['jenis']) {
      case 'Bantuan Anak Sekolah':
        addField('Nama Lengkap', item['nama']);
        addField('Gender', item['gender']);
        addField('Nomor Urut Absen', item['absen']);
        addField('Kelas', item['kelas']);
        addField('Asal Sekolah', item['sekolah']);
        addField('Nama Wali Kelas', item['wali']);
        addField('Nama Orang Tua', item['ortu']);
        addField('Tanggal Penginputan', item['tanggal']);
        break;
      case 'Bantuan Balita':
        addField('Nama Lengkap', item['nama']);
        addField('Gender', item['gender']);
        addField('Usia (bulan)', item['usia']);
        addField('Berat Badan (kg)', item['berat']);
        addField('Tinggi Badan (cm)', item['tinggi']);
        addField('Alergi (Jika Ada)', item['alergi']);
        addField('Nama Orang Tua', item['ortu']);
        addField('Tanggal Penginputan', item['tanggal']);
        break;
      case 'Bantuan Ibu Hamil':
        addField('Nama Lengkap', item['nama']);
        addField('NIK', item['nik']);
        addField('Usia Ibu Hamil (tahun)', item['usiaIbu']);
        addField('Usia Kehamilan (minggu)', item['usiaKehamilan']);
        addField('Alamat Tempat Tinggal', item['alamat']);
        addField('Faskes yang dikunjugi', item['faskes']);
        addField('No.Telp', item['telp']);
        addField('Tanggal Penginputan', item['tanggal']);
        break;
      default:
        children.add(const Text('Data tidak tersedia'));
    }

    // Tambahkan tombol hapus setelah seluruh field
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Konfirmasi Hapus'),
                      content: const Text(
                        'Apakah Anda yakin ingin menghapus data ini?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Ya'),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                setState(() {
                  historiData.remove(item);
                });
              }
            },
            icon: const Icon(Icons.delete, size: 14, color: Colors.white),
            label: const Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
