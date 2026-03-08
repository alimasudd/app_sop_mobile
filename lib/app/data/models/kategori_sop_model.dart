class KategoriSopModel {
  int? id;
  String? kode;
  String? nama;
  String? deskripsi;
  String? status;
  int? sopsCount;

  KategoriSopModel({
    this.id,
    this.kode,
    this.nama,
    this.deskripsi,
    this.status,
    this.sopsCount,
  });

  KategoriSopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    kode = json['kode']?.toString();
    nama = json['nama']?.toString();
    deskripsi = json['deskripsi']?.toString();
    status = json['status']?.toString();
    sopsCount = json['sops_count'] != null ? int.tryParse(json['sops_count'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['kode'] = kode;
    data['nama'] = nama;
    data['deskripsi'] = deskripsi;
    data['status'] = status;
    return data;
  }
}
