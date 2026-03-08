class SopModel {
  int? id;
  int? katsopId;
  String? kode;
  String? nama;
  String? deskripsi;
  String? versi;
  String? tanggalBerlaku;
  String? tanggalKadaluarsa;
  String? status;
  String? periode;
  dynamic kategori; // Usually map, we can leave as dynamic or specific model
  int? langkahCount;
  int? totalPoin;

  SopModel({
    this.id,
    this.katsopId,
    this.kode,
    this.nama,
    this.deskripsi,
    this.versi,
    this.tanggalBerlaku,
    this.tanggalKadaluarsa,
    this.status,
    this.periode,
    this.kategori,
    this.langkahCount,
    this.totalPoin,
  });

  SopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    katsopId = json['katsop_id'] != null ? int.tryParse(json['katsop_id'].toString()) : null;
    kode = json['kode']?.toString();
    nama = json['nama']?.toString();
    deskripsi = json['deskripsi']?.toString();
    versi = json['versi']?.toString();
    tanggalBerlaku = json['tanggal_berlaku']?.toString();
    tanggalKadaluarsa = json['tanggal_kadaluarsa']?.toString();
    status = json['status']?.toString();
    periode = json['periode']?.toString();
    kategori = json['kategori'];
    langkahCount = json['langkah_count'] != null ? int.tryParse(json['langkah_count'].toString()) : 0;
    totalPoin = json['total_poin'] != null ? int.tryParse(json['total_poin'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (katsopId != null) data['katsop_id'] = katsopId;
    data['kode'] = kode;
    data['nama'] = nama;
    data['deskripsi'] = deskripsi;
    data['versi'] = versi;
    data['tanggal_berlaku'] = tanggalBerlaku;
    data['tanggal_kadaluarsa'] = tanggalKadaluarsa;
    data['status'] = status;
    data['periode'] = periode;
    return data;
  }
}
