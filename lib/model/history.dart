class HistoryModel {
  HistoryModel({this.tanggal, this.checkin, this.checkout});

  String tanggal;
  String checkin;
  String checkout;


  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      tanggal: json['tanggal'].toString() as String,
      checkin: json['checkin'] as String,
      checkout: json['checkout'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    "tanggal": tanggal,
    "checkin": checkin,
    "checkout": checkout,
  };

  Map changeMap() {
    var map = new Map<String, dynamic>();
    map["tanggal"] = tanggal;
    map["checkin"] = checkin;
    map["checkout"] = checkout;

    return map;
  }
}