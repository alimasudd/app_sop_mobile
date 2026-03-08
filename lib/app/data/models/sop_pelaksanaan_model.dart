import 'package:app_sop/app/data/models/sop_model.dart';
import 'package:app_sop/app/data/models/sop_langkah_model.dart';
import 'package:app_sop/app/data/models/user_model.dart';
import 'package:app_sop/app/data/models/area_model.dart';
import 'package:app_sop/app/data/models/ruang_model.dart';

class SopPelaksanaanModel {
  int? id;
  int? areaId;
  int? sopId;
  int? sopLangkahId;
  int? ruangId;
  int? statusSop; // 0=Harian, 1=Mingguan, 2=Bulanan, 3=Tahunan
  int? userId;
  int? poin;
  String? des;
  String? url;
  int? deadlineWaktu;
  int? toleransiWaktuSebelum;
  int? toleransiWaktuSesudah;
  int? waktuMulai;
  int? waktuSelesai;
  String? createdAt;
  String? updatedAt;

  // Relations
  SopModel? sop;
  SopLangkahModel? langkah;
  UserModel? user;
  AreaModel? area;
  RuangModel? ruang;

  SopPelaksanaanModel({
    this.id,
    this.areaId,
    this.sopId,
    this.sopLangkahId,
    this.ruangId,
    this.statusSop,
    this.userId,
    this.poin,
    this.des,
    this.url,
    this.deadlineWaktu,
    this.toleransiWaktuSebelum,
    this.toleransiWaktuSesudah,
    this.waktuMulai,
    this.waktuSelesai,
    this.createdAt,
    this.updatedAt,
    this.sop,
    this.langkah,
    this.user,
    this.area,
    this.ruang,
  });

  factory SopPelaksanaanModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return SopPelaksanaanModel(
      id: parseInt(json['id']),
      areaId: parseInt(json['area_id']),
      sopId: parseInt(json['sop_id']),
      sopLangkahId: parseInt(json['sop_langkah_id']),
      ruangId: parseInt(json['ruang_id']),
      statusSop: parseInt(json['status_sop']),
      userId: parseInt(json['user_id']),
      poin: parseInt(json['poin']),
      des: json['des'],
      url: json['url'],
      deadlineWaktu: parseInt(json['deadline_waktu']),
      toleransiWaktuSebelum: parseInt(json['toleransi_waktu_sebelum']),
      toleransiWaktuSesudah: parseInt(json['toleransi_waktu_sesudah']),
      waktuMulai: parseInt(json['waktu_mulai']),
      waktuSelesai: parseInt(json['waktu_selesai']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      sop: json['sop'] != null ? SopModel.fromJson(json['sop']) : null,
      langkah: json['langkah'] != null ? SopLangkahModel.fromJson(json['langkah']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      area: json['area'] != null ? AreaModel.fromJson(json['area']) : null,
      ruang: json['ruang'] != null ? RuangModel.fromJson(json['ruang']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area_id'] = areaId;
    data['sop_id'] = sopId;
    data['sop_langkah_id'] = sopLangkahId;
    data['ruang_id'] = ruangId;
    data['status_sop'] = statusSop;
    data['user_id'] = userId;
    data['poin'] = poin;
    data['des'] = des;
    data['url'] = url;
    data['deadline_waktu'] = deadlineWaktu;
    data['toleransi_waktu_sebelum'] = toleransiWaktuSebelum;
    data['toleransi_waktu_sesudah'] = toleransiWaktuSesudah;
    data['waktu_mulai'] = waktuMulai;
    data['waktu_selesai'] = waktuSelesai;
    return data;
  }
}
