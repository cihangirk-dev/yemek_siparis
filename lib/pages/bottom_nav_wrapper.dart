import 'package:flutter/material.dart';
import 'anasayfa.dart';
import 'favori_sayfa.dart';
import 'giris_sayfa.dart';
import 'sepet_sayfa.dart';
import '../db/kullanici_db.dart';

class BottomNavWrapper extends StatefulWidget {
  final String kullaniciAdi;
  final int kullaniciId;

  const BottomNavWrapper({
    required this.kullaniciAdi,
    required this.kullaniciId,
  });

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      AnaSayfa(
        kullaniciAdi: widget.kullaniciAdi,
        kullaniciId: widget.kullaniciId,
      ),
      Container(),
      FavoriSayfa(
        kullaniciId: widget.kullaniciId,
        kullaniciAdi: widget.kullaniciAdi,
      ),
      SepetSayfa(
        kullaniciAdi: widget.kullaniciAdi,
        kullaniciId: widget.kullaniciId,
      ),
    ]);
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Kullanıcı: ${widget.kullaniciAdi}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout, color: Color(0xFFFFFFFF)),
                    label: const Text(
                      "Çıkış Yap",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      await KullaniciDB.cikisYap();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFEA004B),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
