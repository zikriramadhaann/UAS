import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Widget halaman utama aplikasi
class HomePage extends StatefulWidget {
  final String petugasName;
  final String role;

  // Konstruktor HomePage dengan parameter opsional nama petugas dan role
  // ignore: use_super_parameters
  const HomePage({
    Key? key,
    this.petugasName = 'Nama Petugas',
    this.role = 'Petugas',
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menyimpan tanggal yang sedang difokuskan pada kalender
  DateTime _focusedDay = DateTime.now();
  // Menyimpan tanggal yang dipilih pada kalender
  DateTime? _selectedDay;
  // Menyimpan nama user yang sedang login
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Mengambil nama user dari Firestore berdasarkan UID user yang login
  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Ambil dokumen user dari koleksi 'users' berdasarkan UID
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          // Jika field 'name' ada, gunakan sebagai nama user
          _userName = doc.data()?['name'] ?? widget.petugasName;
        });
      } else {
        // Jika user belum login, gunakan nama default dari widget
        setState(() {
          _userName = widget.petugasName;
        });
      }
    } catch (e) {
      // Jika terjadi error, gunakan nama default dari widget
      setState(() {
        _userName = widget.petugasName;
      });
    }
  }

  // Format tanggal menjadi string dd/MM/yyyy
  String _formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Format tanggal menjadi format Indonesia (contoh: 23 Juni 2025)
  String _formatTanggalIndo(String tanggal) {
    final parts = tanggal.split('/');
    if (parts.length != 3) return tanggal;
    final hari = parts[0];
    final bulan = parts[1];
    final tahun = parts[2];
    const namaBulan = [
      '',
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    int bulanIdx = int.tryParse(bulan) ?? 0;
    String bulanStr = (bulanIdx >= 1 && bulanIdx <= 12) ? namaBulan[bulanIdx] : bulan;
    return '$hari $bulanStr $tahun';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 14, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Teks salam dan nama user
                  Text(
                    'Hallo, ${_userName ?? widget.petugasName}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Teks role user
                  Text(widget.role, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  // Baris tombol shortcut
                  Row(
                    children: [
                      Expanded(
                        child: _buildShortcutButton(
                          color: const Color(0xFF3CD9A2),
                          label: 'Tambah Jadwal',
                          icon: Icons.add,
                          onTap: () => Navigator.pushNamed(context, '/tambah_jadwal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildShortcutButton(
                          color: const Color(0xFFF6E29C),
                          label: 'Rekap Bulanan',
                          icon: Icons.insert_chart,
                          onTap: () => Navigator.pushNamed(context, '/rekap_bulanan'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Judul jadwal
                  const Text(
                    'Jadwal Pemberian Bantuan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Widget kalender
                  _buildCalendar(),
                  const SizedBox(height: 16),
                  // Menampilkan info atau jadwal sesuai tanggal yang dipilih
                  _selectedDay == null
                      ? _buildInfoBox('Pilih tanggal di atas')
                      : _buildJadwalStream(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Widget header/logo aplikasi
  Widget _buildHeader() {
    return Container(
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
    );
  }

  // Widget kalender dengan event dari Firestore
  Widget _buildCalendar() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jadwals').snapshots(),
      builder: (context, snapshot) {
        Set<String> tanggalJadwal = {};
        if (snapshot.hasData) {
          // Ambil semua tanggal jadwal dari data Firestore
          tanggalJadwal = snapshot.data!.docs
              .map((doc) => doc['tanggal'] as String? ?? '')
              .where((tgl) => tgl.isNotEmpty)
              .toSet();
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF3CAD75), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xFF3CAD75),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
            // Menandai tanggal yang memiliki jadwal
            eventLoader: (day) {
              final tgl = _formatTanggal(day);
              if (tanggalJadwal.contains(tgl)) {
                return [tgl];
              }
              return [];
            },
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan jadwal pada tanggal yang dipilih
  Widget _buildJadwalStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jadwals')
          .where('tanggal', isEqualTo: _formatTanggal(_selectedDay!))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading saat data masih dimuat
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Tampilkan pesan error jika terjadi kesalahan
          return _buildInfoBox('Terjadi kesalahan saat memuat data.');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Tampilkan pesan jika tidak ada jadwal pada tanggal tersebut
          return _buildInfoBox('Tidak ada jadwal pembagian pada tanggal ini');
        }
        final docs = snapshot.data!.docs;
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF3CAD75), width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Jenis Bantuan', data['jenis_bantuan']),
                  _buildDetailRow(
                    'Tanggal',
                    data['tanggal'] != null ? _formatTanggalIndo(data['tanggal']) : null,
                  ),
                  _buildDetailRow('Waktu', data['waktu']),
                  _buildDetailRow('Lokasi Pembagian', data['lokasi']),
                  _buildDetailRow('Catatan', data['catatan']),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Widget bottom navigation bar
  Widget _buildBottomNavBar() {
    return Container(
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
          currentIndex: 0,
          selectedItemColor: const Color(0xFF3CAD75),
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (idx) {
            // Navigasi ke halaman sesuai index
            switch (idx) {
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
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Formulir'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histori'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  // Widget tombol shortcut (Tambah Jadwal, Rekap Bulanan)
  Widget _buildShortcutButton({
    required Color color,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan detail jadwal dalam bentuk baris
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3CAD75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  ':',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3CAD75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value == null || value.isEmpty ? '-' : value,
              style: const TextStyle(color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan pesan informasi atau error
  Widget _buildInfoBox(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF3CAD75), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey)),
    );
  }
}
