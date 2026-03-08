class TugasSopModel {
  int? id;
  int? sopId;
  int? sopLangkahId;
  int? userId;
  String? createdAt;
  Map<String, dynamic>? sop;
  Map<String, dynamic>? langkah;
  Map<String, dynamic>? user;

  TugasSopModel({
    this.id,
    this.sopId,
    this.sopLangkahId,
    this.userId,
    this.createdAt,
    this.sop,
    this.langkah,
    this.user,
  });

  TugasSopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    sopId = json['sop_id'] != null ? int.tryParse(json['sop_id'].toString()) : null;
    sopLangkahId = json['sop_langkah_id'] != null ? int.tryParse(json['sop_langkah_id'].toString()) : null;
    userId = json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null;
    createdAt = json['created_at']?.toString();
    sop = json['sop'];
    langkah = json['langkah'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (sopId != null) data['sop_id'] = sopId;
    if (sopLangkahId != null) data['sop_langkah_id'] = sopLangkahId;
    if (userId != null) data['user_id'] = userId;
    return data;
  }
}
