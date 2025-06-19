import 'package:flutter/material.dart';
import 'edit_profil.dart';

class ProfilPage extends StatelessWidget {
  final String petugasName;
  final String role;
  final String email;

  const ProfilPage({
    super.key,
    this.petugasName = 'Zikri Ramadhan',
    this.role = 'Petugas Lapangan',
    this.email = 'zikriramadhan@gmail.com',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
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

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                children: [
                  // Foto profil
                  Container(
                    width: 208,
                    height: 208,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3CAD75),
                        width: 3,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profil.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Informasi user dalam box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(Icons.person, petugasName),
                        const Divider(),
                        _buildInfoTile(Icons.work_outline, role),
                        const Divider(),
                        _buildInfoTile(Icons.email_outlined, email),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol Edit Profil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Edit Profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3CAD75),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Keluar',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            currentIndex: 3,
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
                  // Sudah di halaman profil
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

  Widget _buildInfoTile(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF3CAD75)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
