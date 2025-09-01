import 'db_provider.dart';

class FavoriDB {
  static Future<void> favoriEkle(int kullaniciId, Map<String, dynamic> yemek) async {
    final db = await DBProvider.getDatabase();
    await db.insert(
      'favori',
      {
        'kullanici_id': kullaniciId,
        'yemek_id': yemek['yemek_id'],
        'yemek_adi': yemek['yemek_adi'],
        'yemek_resim_adi': yemek['yemek_resim_adi'],
        'yemek_fiyat': yemek['yemek_fiyat'],
      },
    );
  }

  static Future<void> favoriSil(int kullaniciId, String yemekId) async {
    final db = await DBProvider.getDatabase();
    await db.delete(
      'favori',
      where: 'kullanici_id = ? AND yemek_id = ?',
      whereArgs: [kullaniciId, yemekId],
    );
  }

  static Future<List<Map<String, dynamic>>> favorileriGetir(int kullaniciId) async {
    final db = await DBProvider.getDatabase();
    return await db.query(
      'favori',
      where: 'kullanici_id = ?',
      whereArgs: [kullaniciId],
    );
  }

  static Future<bool> favoriVarMi(int kullaniciId, String yemekId) async {
    final db = await DBProvider.getDatabase();
    final result = await db.query(
      'favori',
      where: 'kullanici_id = ? AND yemek_id = ?',
      whereArgs: [kullaniciId, yemekId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
