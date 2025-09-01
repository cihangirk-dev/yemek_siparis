import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sepet_repository.dart';
import '../db/favori_db.dart';
import '../models/yemek.dart';

class DetaySayfa extends StatefulWidget {
  final Yemek yemek;
  final String kullaniciAdi;
  final int kullaniciId;

  const DetaySayfa({
    super.key,
    required this.yemek,
    required this.kullaniciAdi,
    required this.kullaniciId,
  });

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  int _adet = 1;
  bool _isFavori = false;

  @override
  void initState() {
    super.initState();
    _favoriKontrol();
  }

  Future<void> _favoriKontrol() async {
    final varMi =
    await FavoriDB.favoriVarMi(widget.kullaniciId, widget.yemek.yemekId);
    setState(() {
      _isFavori = varMi;
    });
  }

  void _adetArttir() {
    setState(() {
      _adet++;
    });
  }

  void _adetAzalt() {
    if (_adet > 1) {
      setState(() {
        _adet--;
      });
    }
  }

  Future<void> _favoriToggle() async {
    if (_isFavori) {
      await FavoriDB.favoriSil(widget.kullaniciId, widget.yemek.yemekId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "${widget.yemek.yemekAdi} favorilerden kaldırıldı",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
            backgroundColor: Color(0xFFD70F64),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
      );
    } else {
      await FavoriDB.favoriEkle(widget.kullaniciId, {
        'yemek_id': widget.yemek.yemekId,
        'yemek_adi': widget.yemek.yemekAdi,
        'yemek_resim_adi': widget.yemek.yemekResimAdi,
        'yemek_fiyat': widget.yemek.yemekFiyat,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "${widget.yemek.yemekAdi} favorilere eklendi",
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
      );
    }
    _favoriKontrol();
  }

  Future<void> _sepeteEkle() async {
    await SepetRepository().sepeteYemekEkle(
      yemekAdi: widget.yemek.yemekAdi,
      yemekResimAdi: widget.yemek.yemekResimAdi,
      yemekFiyat: widget.yemek.fiyatAsInt,
      yemekSiparisAdet: _adet,
      kullaniciAdi: widget.kullaniciAdi,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "${widget.yemek.yemekAdi} sepete eklendi ($_adet adet)",
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toplamFiyat = widget.yemek.fiyatAsInt * _adet;

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA004B),
        title: Text(
          "Ürün Detayı",
          style: GoogleFonts.baloo2(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Color(0xFFFFFFFF),),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavori ? Icons.favorite : Icons.favorite_border_outlined,
              color: Color(0xFFFFFFFF),
            ),
            onPressed: _favoriToggle,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                widget.yemek.yemekAdi,
                style: GoogleFonts.baloo2(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "http://kasimadalan.pe.hu/yemekler/resimler/${widget.yemek.yemekResimAdi}",
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "${widget.yemek.yemekFiyat} ₺",
                style: GoogleFonts.baloo2(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.indeterminate_check_box, size: 50, color: Colors.red),
                    onPressed: _adetAzalt,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$_adet",
                      style: GoogleFonts.baloo2(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_box, size: 50, color: Colors.green),
                    onPressed: _adetArttir,
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Toplam: $toplamFiyat ₺",
                      style: GoogleFonts.baloo2(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA004B),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _sepeteEkle,
                    child: Text(
                      "Sepete Ekle",
                      style: GoogleFonts.baloo2(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
