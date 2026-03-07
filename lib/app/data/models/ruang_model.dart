class RuangModel {
  int? id;
  int? areaId;
  String? namaArea;
  String? namaRuang;
  String? deskripsi;
  String? createdAt;

  RuangModel({
    this.id,
    this.areaId,
    this.namaArea,
    this.namaRuang,
    this.deskripsi,
    this.createdAt,
  });

  RuangModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaId = json['area_id'];
    namaArea = json['nama_area'];
    namaRuang = json['nama_ruang'];
    deskripsi = json['deskripsi'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['area_id'] = areaId;
    data['nama_area'] = namaArea;
    data['nama_ruang'] = namaRuang;
    data['deskripsi'] = deskripsi;
    data['created_at'] = createdAt;
    return data;
  }
}
