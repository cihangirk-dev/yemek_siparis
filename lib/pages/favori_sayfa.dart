import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sepet_repository.dart';
import '../db/favori_db.dart';
import '../models/yemek.dart';
import 'detay_sayfa.dart';

class FavoriSayfa extends StatefulWidget {
  final int kullaniciId;
  final String kullaniciAdi;

  const FavoriSayfa({
    super.key,
    required this.kullaniciId,
    required this.kullaniciAdi,
  });

  @override
  State<FavoriSayfa> createState() => _FavoriSayfaState();
}

class _FavoriSayfaState extends State<FavoriSayfa> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _tumFavoriler = [];
  List<Map<String, dynamic>> _filtreliFavoriler = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _favoriAra(_searchController.text);
    });
    favorileriYukle();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> favorileriYukle() async {
    try {
      setState(() {
        isLoading = true;
      });
      final list = await FavoriDB.favorileriGetir(widget.kullaniciId);
      setState(() {
        _tumFavoriler = list;
        _filtreliFavoriler = list;
        isLoading = false;
      });
    } catch (e) {
      print("Favori listesi yüklenirken bir hata oluştu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _favoriAra(String query) {
    if (_tumFavoriler.isEmpty) return;

    if (query.isEmpty) {
      setState(() {
        _filtreliFavoriler = _tumFavoriler;
      });
    } else {
      final filtreli = _tumFavoriler
          .where(
            (yemek) =>
                yemek['yemek_adi'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      setState(() {
        _filtreliFavoriler = filtreli;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA004B),
        title: Text(
          'Favorilerim',
          style: GoogleFonts.baloo2(
            color: const Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Favori ara...',
                hintStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtreliFavoriler.isEmpty
                  ? const Center(child: Text("Favori bulunamadı"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: _filtreliFavoriler.length,
                      itemBuilder: (context, index) {
                        final yemek = _filtreliFavoriler[index];
                        return Card(
                          color: const Color(0xFFFFFFFF),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              final favoriYemek = Yemek(
                                yemekId: yemek['yemek_id'].toString(),
                                yemekAdi: yemek['yemek_adi'].toString(),
                                yemekResimAdi: yemek['yemek_resim_adi']
                                    .toString(),
                                yemekFiyat: yemek['yemek_fiyat'].toString(),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetaySayfa(
                                    yemek: favoriYemek,
                                    kullaniciAdi: widget.kullaniciAdi,
                                    kullaniciId: widget.kullaniciId,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: Image.network(
                                          "http://kasimadalan.pe.hu/yemekler/resimler/${yemek['yemek_resim_adi']}",
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          yemek['yemek_adi'],
                                          style: GoogleFonts.baloo2(
                                            color: const Color(0xFF8B0000),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${yemek['yemek_fiyat']} ₺",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outlined,
                                              color: Color(0xFFD70F64),
                                            ),
                                            onPressed: () async {
                                              await SepetRepository()
                                                  .sepeteYemekEkle(
                                                    yemekAdi:
                                                        yemek['yemek_adi'],
                                                    yemekResimAdi:
                                                        yemek['yemek_resim_adi'],
                                                    yemekFiyat: int.parse(
                                                      yemek['yemek_fiyat'],
                                                    ),
                                                    yemekSiparisAdet: 1,
                                                    kullaniciAdi:
                                                        widget.kullaniciAdi,
                                                  );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "${yemek['yemek_adi']} sepete eklendi",
                                                    style: const TextStyle(
                                                      color: Color(0xFFFFFFFF),
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await FavoriDB.favoriSil(
                                        widget.kullaniciId,
                                        yemek['yemek_id'],
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${yemek['yemek_adi']} favorilerden kaldırıldı",
                                            style: const TextStyle(
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                          backgroundColor: const Color(
                                            0xFFD70F64,
                                          ),
                                          duration: const Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      );
                                      favorileriYukle();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
