import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/sepet_cubit.dart';
import '../models/sepet_yemek.dart';
import 'bottom_nav_wrapper.dart';
import 'detay_sayfa.dart';

class SepetSayfa extends StatefulWidget {
  final String kullaniciAdi;
  final int kullaniciId;

  const SepetSayfa({
    super.key,
    required this.kullaniciAdi,
    required this.kullaniciId,
  });

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  "Siparişiniz alınmıştır.",
                  style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<SepetCubit>().sepettekiYemekleriGetir(widget.kullaniciAdi);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA004B),
        title: Text(
          "Sepetim",
          style: GoogleFonts.baloo2(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SepetCubit, List<SepetYemek>>(
        builder: (context, sepetYemekler) {
          if (sepetYemekler.isEmpty) {
            return const Center(child: Text("Sepetiniz boş"));
          }
          final toplam = context.read<SepetCubit>().toplamTutar();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: sepetYemekler.length,
                  itemBuilder: (context, index) {
                    final yemek = sepetYemekler[index];
                    return Card(
                      color: const Color(0xFFFFFFFF),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemekResimAdi}",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          yemek.yemekAdi,
                          style: GoogleFonts.baloo2(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "${yemek.toplamTutar} ₺",
                              style: GoogleFonts.baloo2(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 30),
                            IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                if (yemek.adetAsInt > 1) {
                                  context.read<SepetCubit>().adetGuncelle(
                                    yemek: yemek,
                                    yeniAdet: yemek.adetAsInt - 1,
                                    kullaniciAdi: widget.kullaniciAdi,
                                  );
                                }
                              },
                            ),
                            Text(
                              "${yemek.yemekSiparisAdet}",
                              style: GoogleFonts.baloo2(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.green),
                              onPressed: () {
                                context.read<SepetCubit>().adetGuncelle(
                                  yemek: yemek,
                                  yeniAdet: yemek.adetAsInt + 1,
                                  kullaniciAdi: widget.kullaniciAdi,
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<SepetCubit>().sepettenYemekSil(
                              sepetYemekId: int.parse(yemek.sepetYemekId),
                              kullaniciAdi: widget.kullaniciAdi,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Toplam: $toplam ₺",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFEA004B),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA004B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (sepetYemekler.isEmpty) return;

                      await context.read<SepetCubit>().sepetiTemizle(
                        kullaniciAdi: widget.kullaniciAdi,
                      );

                      _showSuccessDialog();

                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomNavWrapper(
                              kullaniciAdi: widget.kullaniciAdi,
                              kullaniciId: widget.kullaniciId,
                            ),
                          ),
                              (route) => false,
                        );
                      }
                    },
                    child: Text(
                      "Sipariş Ver",
                      style: GoogleFonts.baloo2(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}