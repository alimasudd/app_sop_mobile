class UserModel {
  int? id;
  String? nama;
  String? email;
  String? hp;
  int? levelId;
  int? statusAktif;

  UserModel({
    this.id,
    this.nama,
    this.email,
    this.hp,
    this.levelId,
    this.statusAktif,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    email = json['email'];
    hp = json['hp'];
    levelId = json['levelId'] ?? json['level_id'];
    statusAktif = json['statusAktif'] ?? json['status_aktif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama'] = nama;
    data['email'] = email;
    data['hp'] = hp;
    data['levelId'] = levelId;
    data['statusAktif'] = statusAktif;
    return data;
  }
}
