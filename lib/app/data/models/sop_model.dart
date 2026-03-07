class SopModel {
  int? id;
  String? kode;
  String? nama;
  String? deskripsi;
  String? versi;
  String? status;

  SopModel({
    this.id,
    this.kode,
    this.nama,
    this.deskripsi,
    this.versi,
    this.status,
  });

  SopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kode = json['kode']?.toString();
    nama = json['nama']?.toString();
    deskripsi = json['deskripsi']?.toString();
    versi = json['versi']?.toString();
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['kode'] = kode;
    data['nama'] = nama;
    data['deskripsi'] = deskripsi;
    data['versi'] = versi;
    data['status'] = status;
    return data;
  }
}
