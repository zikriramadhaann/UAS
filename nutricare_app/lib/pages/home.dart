import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  final String petugasName;
  final String role;

  const HomePage({
    super.key,
    this.petugasName = 'Zikri Ramadhan',
    this.role = 'Petugas Lapangan',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime.utc(2025, 6, 28): [
      {
        'lokasi': 'SDN 24 Selayo',
        'jam': '09:00–11:00',
        'jenis': 'Anak Sekolah',
        'estimasi': '50 orang',
      },
    ],
  };

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Map<String, String>> get _selectedEvents => _events[_selectedDay] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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

              // Body content
              Container(
                color: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  14,
                  24,
                ), // tambahkan bottom padding lebih besar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hallo, ${widget.petugasName}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.role,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Shortcut Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildShortcutButton(
                            color: const Color(0xFF3CD9A2),
                            label: 'Tambah Jadwal',
                            icon: Icons.add,
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  '/tambah_jadwal',
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildShortcutButton(
                            color: const Color(0xFFF6E29C),
                            label: 'Rekap Bulanan',
                            icon: Icons.insert_chart,
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  '/rekap_bulanan',
                                ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    const Text(
                      'Jadwal Pemberian Bantuan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Kalender
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF3CAD75),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2024, 1, 1),
                        lastDay: DateTime.utc(2026, 12, 31),
                        focusedDay: _focusedDay,
                        eventLoader:
                            (day) =>
                                _events[DateTime.utc(
                                  day.year,
                                  day.month,
                                  day.day,
                                )] ??
                                [],
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
                        selectedDayPredicate:
                            (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selected, focused) {
                          setState(() {
                            _selectedDay = selected;
                            _focusedDay = focused;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // List Jadwal
                    if (_selectedDay == null)
                      const Center(child: Text('Pilih tanggal di atas'))
                    else if (_selectedEvents.isEmpty)
                      const Center(
                        child: Text(
                          'Tidak ada jadwal pembagian pada tanggal ini',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ..._selectedEvents.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(item['lokasi']!),
                            subtitle: Text(
                              '${item['jam']} • ${item['jenis']} • ${item['estimasi']}',
                            ),
                            trailing: TextButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: const Text(
                                          'Yakin ingin menghapus jadwal ini?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                );
                                if (confirm == true) {
                                  setState(() {
                                    final dateKey = DateTime.utc(
                                      _selectedDay!.year,
                                      _selectedDay!.month,
                                      _selectedDay!.day,
                                    );
                                    _events[dateKey]?.removeAt(idx);
                                    if (_events[dateKey]?.isEmpty ?? false) {
                                      _events.remove(dateKey);
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
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
            currentIndex: 0,
            selectedItemColor: const Color(0xFF3CAD75),
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            onTap: (idx) {
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
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
