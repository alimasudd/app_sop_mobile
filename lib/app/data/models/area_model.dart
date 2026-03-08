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
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    nama = json['nama']?.toString();
    des = json['des']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['nama'] = nama;
    data['des'] = des;
    return data;
  }
}
