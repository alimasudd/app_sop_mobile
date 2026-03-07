import 'package:app_sop/app/data/models/area_model.dart';

class RuangModel {
  int? id;
  int? areaId;
  String? nama;
  String? des;
  String? createdAt;
  AreaModel? area;

  RuangModel({
    this.id,
    this.areaId,
    this.nama,
    this.des,
    this.createdAt,
    this.area,
  });

  RuangModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaId = json['area_id'];
    nama = json['nama'];
    des = json['des'];
    createdAt = json['created_at'];
    if (json['area'] != null) {
      area = AreaModel.fromJson(json['area']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['area_id'] = areaId;
    data['nama'] = nama;
    data['des'] = des;
    data['created_at'] = createdAt;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    return data;
  }
}
