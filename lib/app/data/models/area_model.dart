class AreaModel {
  int? id;
  String? namaArea;
  String? deskripsi;

  AreaModel({
    this.id,
    this.namaArea,
    this.deskripsi,
  });

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaArea = json['nama_area'];
    deskripsi = json['deskripsi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['nama_area'] = namaArea;
    data['deskripsi'] = deskripsi;
    return data;
  }
}
