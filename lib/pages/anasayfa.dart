import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/yemekler_cubit.dart';
import '../data/sepet_repository.dart';
import '../db/favori_db.dart';
import '../models/yemek.dart';
import 'detay_sayfa.dart';

class AnaSayfa extends StatefulWidget {
  final String kullaniciAdi;
  final int kullaniciId;

  const AnaSayfa({required this.kullaniciAdi, required this.kullaniciId});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<YemeklerCubit>();

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFEA004B),
        title: Text(
          'Yemek Kapında',
          style: GoogleFonts.baloo2(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Yemek ara...',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Color(0xFFFFFFFF),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
              onChanged: (value) {
                cubit.yemekAra(value);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<YemeklerCubit, List<Yemek>>(
                builder: (context, yemekler) {
                  final cubit = context.read<YemeklerCubit>();
        
                  if (cubit.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
        
                  if (yemekler.isEmpty) {
                    return Center(child: Text("Yemek bulunamadı"));
                  }
        
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: yemekler.length,
                    itemBuilder: (context, index) {
                      final yemek = yemekler[index];
                      return Card(
                        color: Color(0xFFFFFFFF),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetaySayfa(
                                  yemek: yemek,
                                  kullaniciAdi: widget.kullaniciAdi,
                                  kullaniciId: widget.kullaniciId,
                                ),
                              ),
                            );
                          },

                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemekResimAdi}",
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        yemek.yemekAdi,
                                        style: GoogleFonts.baloo2(
                                          color: Color(0xFF8B0000),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${yemek.yemekFiyat} ₺",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_circle_outlined,
                                            color: Color(0xFFD70F64),
                                          ),
                                          onPressed: () async {
                                            await SepetRepository().sepeteYemekEkle(
                                              yemekAdi: yemek.yemekAdi,
                                              yemekResimAdi: yemek.yemekResimAdi,
                                              yemekFiyat: yemek.fiyatAsInt,
                                              yemekSiparisAdet: 1,
                                              kullaniciAdi: widget.kullaniciAdi,
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                    "${yemek.yemekAdi} sepete eklendi",
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
                                child: FutureBuilder<bool>(
                                  future: FavoriDB.favoriVarMi(
                                    widget.kullaniciId,
                                    yemek.yemekId,
                                  ),
                                  builder: (context, snapshot) {
                                    final isFavori = snapshot.data ?? false;

                                    return IconButton(
                                      icon: Icon(
                                        isFavori
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        if (isFavori) {
                                          await FavoriDB.favoriSil(
                                              widget.kullaniciId, yemek.yemekId);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${yemek.yemekAdi} favorilerden kaldırıldı",
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
                                          await FavoriDB.favoriEkle(
                                            widget.kullaniciId,
                                            {
                                              'yemek_id': yemek.yemekId,
                                              'yemek_adi': yemek.yemekAdi,
                                              'yemek_resim_adi': yemek.yemekResimAdi,
                                              'yemek_fiyat': yemek.yemekFiyat,
                                            },
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                  "${yemek.yemekAdi} favorilere eklendi",
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
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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