import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
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

  List<Map<String, dynamic>> historiData = [];
  bool isLoading = true;

  Future<void> fetchHistoriData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('formulirs')
              .where(
                'jenis_formulir',
                isEqualTo: _getFirestoreFilterValue(selectedFilter),
              )
              .get();

      List<Map<String, dynamic>> fetchedData = [];
      for (var doc in querySnapshot.docs) {
        fetchedData.add({
          ...doc.data(),
          'documentId': doc.id,
        }); // Include document ID
      }

      setState(() {
        historiData = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
        historiData = []; // Clear data on error
      });
      // Optionally show an error message to the user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load data. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String _getFirestoreFilterValue(String filter) {
    switch (filter) {
      case 'Bantuan Anak Sekolah':
        return 'Bantuan Anak Sekolah';
      case 'Bantuan Balita':
        return 'Bantuan Balita';
      case 'Bantuan Ibu Hamil':
        return 'Bantuan Ibu Hamil';
      default:
        return ''; // Should not happen with defined filters
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(
      'id_ID',
      null,
    ); // Initialize date formatting for Indonesian locale
    selectedFilter = filters[0];
    fetchHistoriData(); // Fetch data initially
  }

  @override
  void didUpdateWidget(covariant HistoriPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchHistoriData();
  }

  @override
  Widget build(BuildContext context) {
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
                            fetchHistoriData(); // Fetch data when filter changes
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                      ), // Adjusted padding
                      itemCount: historiData.length,
                      itemBuilder: (context, index) {
                        final item = historiData[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                          ), // Adjusted margin
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Adjusted radius
                              side: const BorderSide(
                                // Added border side
                                color: Color(0xFF3CAD75),
                                width: 1.5,
                              ),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                // Adjusted padding
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

  Widget _buildCardContent(Map<String, dynamic> item) {
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

    switch (item['jenis_formulir']) {
      case 'Bantuan Anak Sekolah':
        addField('Nama Lengkap', item['nama_lengkap']);
        addField('Gender', item['gender']);
        addField('Nomor Urut Absen', item['nomor_urut_absen']);
        addField('Kelas', item['kelas']);
        addField('Asal Sekolah', item['asal_sekolah']);
        addField('Nama Wali Kelas', item['nama_wali_kelas']);
        addField('Nama Orang Tua', item['nama_orang_tua']);
        addField(
          'Tanggal Penginputan',
          item['timestamp'] != null
              ? DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(item['timestamp'].toDate())
              : '-',
        );
        break;
      case 'Bantuan Balita':
        addField('Nama Lengkap', item['nama_lengkap']);
        addField('Gender', item['gender']);
        addField('Usia (bulan)', item['usia_bulan']?.toString());
        addField('Berat Badan (kg)', item['berat_badan_kg']?.toString());
        addField('Tinggi Badan (cm)', item['tinggi_badan_cm']?.toString());
        addField('Alergi (Jika Ada)', item['alergi']);
        addField('Nama Orang Tua', item['nama_orang_tua']);
        addField(
          'Tanggal Penginputan',
          item['timestamp'] != null
              ? DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(item['timestamp'].toDate())
              : '-',
        );
        break;
      case 'Bantuan Ibu Hamil':
        addField('Nama Lengkap', item['nama_lengkap']);
        addField('NIK', item['nik']);
        addField('Usia Ibu Hamil (tahun)', item['usia_ibu_hamil_tahun']);
        addField('Usia Kehamilan (minggu)', item['usia_kehamilan_minggu']);
        addField('Alamat Tempat Tinggal', item['alamat_tempat_tinggal']);
        addField('No.Telp', item['no_telepon']);
        addField('Faskes yang dikunjungi', item['faskes_dikunjungi']);
        addField(
          'Tanggal Penginputan',
          item['timestamp'] != null
              ? DateFormat(
                'dd MMMM yyyy',
                'id_ID',
              ).format(item['timestamp'].toDate())
              : '-',
        );
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
                  // Get the document ID from the item map
                  String? documentId = item['documentId'];
                  if (documentId != null) {
                    FirebaseFirestore.instance
                        .collection('formulirs')
                        .doc(documentId)
                        .delete();
                  }
                  historiData.remove(item);
                }); // Missing closing brace here
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
