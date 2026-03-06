class UserModel {
  int? id;
  String? nama;
  String? email;
  String? hp;
  String? nik;
  int? levelId;
  int? statusAktif;
  String? password;
  String? jabatan;

  UserModel({
    this.id,
    this.nama,
    this.email,
    this.hp,
    this.nik,
    this.password,
    this.jabatan,
    this.levelId,
    this.statusAktif,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    nama = json['nama']?.toString();
    email = json['email']?.toString();
    hp = json['hp']?.toString();
    nik = json['nik']?.toString();
    jabatan = json['jabatan']?.toString();
    levelId = _toInt(json['levelId'] ?? json['level_id']);
    statusAktif = _toInt(json['statusAktif'] ?? json['status_aktif']);
  }

  // Helper to safely parse int from String or int
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['email'] = email;
    data['hp'] = hp;
    data['nik'] = nik;
    data['password'] = password;
    data['jabatan'] = jabatan;
    data['level_id'] = levelId;
    data['status_aktif'] = statusAktif;
    return data;
  }
}
