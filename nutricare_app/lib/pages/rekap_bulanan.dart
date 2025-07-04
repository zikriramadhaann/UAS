import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RekapBulananPage extends StatelessWidget {
  const RekapBulananPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data bantuan per wilayah
    final List<Map<String, dynamic>> bantuanPerWilayah = [
      {
        'wilayah': 'Tigo Lurah',
        'anakSekolah': 80,
        'balita': 50,
        'ibuHamil': 25,
      },
      {
        'wilayah': 'Kubung',
        'anakSekolah': 40,
        'balita': 15,
        'ibuHamil': 10,
      },
      {
        'wilayah': 'Gununng Talang',
        'anakSekolah': 30,
        'balita': 10,
        'ibuHamil': 5,
      },
    ];

    // Hitung total bantuan per wilayah
    for (var wilayah in bantuanPerWilayah) {
      wilayah['total'] =
          (wilayah['anakSekolah'] as int) +
          (wilayah['balita'] as int) +
          (wilayah['ibuHamil'] as int);
    }

    // Hitung total bantuan untuk masing-masing kategori
    final int _ = bantuanPerWilayah.fold(
      0,
      (sum, item) => sum + (item['anakSekolah'] as int),
    );
    final int _ = bantuanPerWilayah.fold(
      0,
      (sum, item) => sum + (item['balita'] as int),
    );
    // ignore: unused_local_variable
    final int totalIbuHamil = bantuanPerWilayah.fold(
      0,
      (sum, item) => sum + (item['ibuHamil'] as int),
    );

    // Hitung ulang total bantuan per wilayah
    for (var wilayah in bantuanPerWilayah) {
      wilayah['total'] =
          wilayah['anakSekolah'] + wilayah['balita'] + wilayah['ibuHamil'];
    }

    // Urutkan wilayah berdasarkan total bantuan (tertinggi ke terendah)
    bantuanPerWilayah.sort((a, b) => b['total'].compareTo(a['total']));
    final Map<String, dynamic> wilayahTertinggi = bantuanPerWilayah.first;

    // Buat rekomendasi wilayah prioritas
    final String rekomendasi =
        'Utamakan wilayah ${wilayahTertinggi['wilayah']} karena total permintaannya tertinggi bulan ini (${wilayahTertinggi['total']} orang).';

    // Widget rekomendasi wilayah prioritas
    final rekomendasiWidget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF3CAD75), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: Color(0xFF3CAD75), size: 36),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'Anak Sekolah: ${wilayahTertinggi['anakSekolah']}\n'
              'Balita: ${wilayahTertinggi['balita']}\n'
              'Ibu Hamil: ${wilayahTertinggi['ibuHamil']}\n\n'
              '$rekomendasi',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );

    // Inisialisasi format tanggal lokal Indonesia
    initializeDateFormatting('id_ID', null);
    final String namaBulan = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header aplikasi
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
          // Judul dan info bulan rekap
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 4),
            child: Column(
              children: [
                const Text(
                  'Hasil Rekap Bulanan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  // ignore: unnecessary_string_interpolations
                  '$namaBulan',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Kabupaten Solok',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
          // Konten utama (grafik dan rekomendasi)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
              children: [
                const SizedBox(height: 18),
                const Text(
                  'Grafik Bantuan per Wilayah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Grafik batang bantuan per wilayah
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF3CAD75),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: 160,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              // Tampilkan nama wilayah di sumbu X
                              final idx = value.toInt();
                              if (idx >= 0 && idx < bantuanPerWilayah.length) {
                                return Text(
                                  bantuanPerWilayah[idx]['wilayah'],
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            reservedSize: 32,
                            getTitlesWidget: (value, _) {
                              // Tampilkan angka pada sumbu Y
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(bantuanPerWilayah.length, (i) {
                        // Data batang untuk setiap wilayah
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  (bantuanPerWilayah[i]['total'] as int)
                                      .toDouble(),
                              color: Colors.lightBlue,
                              width: 24,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Tampilkan rekomendasi wilayah prioritas
                rekomendasiWidget,
              ],
            ),
          ),
        ],
      ),
      // Navigasi bawah aplikasi
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
              // Navigasi ke halaman sesuai indeks
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
}