import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../db/kullanici_db.dart';
import 'bottom_nav_wrapper.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFEA004B),
        title: Text(
          "Yemek Kapında",
          style: GoogleFonts.baloo2(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Image.asset(
                'assets/logo/yemek_logo.png',
                height: 300,
              ),
              TextField(
                controller: _controller,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  hintText: "Kullanıcı Adı",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEA004B),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    final username = _controller.text.trim().toUpperCase();
                    if (username.isEmpty) return;
                    int id = await KullaniciDB.girisYap(username);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BottomNavWrapper(
                          kullaniciAdi: username,
                          kullaniciId: id,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Giriş Yap",
                    style: GoogleFonts.baloo2(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

