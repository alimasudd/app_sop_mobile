class SopLangkahModel {
  int? id;
  int? sopId;
  int? ruangId;
  int? userId;
  int? jabatanId;
  int? urutan;
  String? deskripsiLangkah;
  int? wajib; // In Laravel it's boolean, but API might return 1/0 or true/false
  int? poin;
  String? deadlineWaktu; // Will treat as string to match UI if needed
  String? toleransiWaktuSebelum;
  String? toleransiWaktuSesudah;
  int? waReminder;
  String? waJamKirim;

  // Relations - mapped loosely or as dynamic maps for now, or you can import exact models later
  dynamic sop;
  dynamic ruang;
  dynamic user;

  SopLangkahModel({
    this.id,
    this.sopId,
    this.ruangId,
    this.userId,
    this.jabatanId,
    this.urutan,
    this.deskripsiLangkah,
    this.wajib,
    this.poin,
    this.deadlineWaktu,
    this.toleransiWaktuSebelum,
    this.toleransiWaktuSesudah,
    this.waReminder,
    this.waJamKirim,
    this.sop,
    this.ruang,
    this.user,
  });

  SopLangkahModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    sopId = json['sop_id'] != null ? int.tryParse(json['sop_id'].toString()) : null;
    ruangId = json['ruang_id'] != null ? int.tryParse(json['ruang_id'].toString()) : null;
    userId = json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null;
    jabatanId = json['jabatan_id'] != null ? int.tryParse(json['jabatan_id'].toString()) : null;
    urutan = json['urutan'] != null ? int.tryParse(json['urutan'].toString()) : null;
    deskripsiLangkah = json['deskripsi_langkah']?.toString();
    wajib = json['wajib'] == true || json['wajib'] == 1 || json['wajib'] == '1' ? 1 : 0;
    poin = json['poin'] != null ? int.tryParse(json['poin'].toString()) : null;
    deadlineWaktu = json['deadline_waktu']?.toString();
    toleransiWaktuSebelum = json['toleransi_waktu_sebelum']?.toString();
    toleransiWaktuSesudah = json['toleransi_waktu_sesudah']?.toString();
    waReminder = json['wa_reminder'] == true || json['wa_reminder'] == 1 || json['wa_reminder'] == '1' ? 1 : 0;
    waJamKirim = json['wa_jam_kirim']?.toString();
    
    sop = json['sop'];
    ruang = json['ruang'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['sop_id'] = sopId;
    data['ruang_id'] = ruangId;
    data['user_id'] = userId;
    data['jabatan_id'] = jabatanId;
    data['urutan'] = urutan;
    data['deskripsi_langkah'] = deskripsiLangkah;
    data['wajib'] = wajib;
    data['poin'] = poin;
    data['deadline_waktu'] = deadlineWaktu;
    data['toleransi_waktu_sebelum'] = toleransiWaktuSebelum;
    data['toleransi_waktu_sesudah'] = toleransiWaktuSesudah;
    data['wa_reminder'] = waReminder;
    data['wa_jam_kirim'] = waJamKirim;
    return data;
  }
}
