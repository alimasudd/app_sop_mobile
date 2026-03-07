class AreaModel {
  int? id;
  String? nama;
  String? des;

  AreaModel({
    this.id,
    this.nama,
    this.des,
  });

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    des = json['des'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['nama'] = nama;
    data['des'] = des;
    return data;
  }
}
