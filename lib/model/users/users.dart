class UsersModel {
  UsersModel({this.username, this.password, this.status, this.fullname, this.id_nik, this.foto, this.id_mbp, this.mbp_name, this.id_cluster, this.cluster_name,});

  String username;
  String password;
  int status;
  String fullname;
  String id_nik;
  String foto;
  int id_mbp;
  String mbp_name;
  int id_cluster;
  String cluster_name;

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      username: json['username'] as String,
      password: json['password'] as String,
      status: json['status'] as int,
      fullname: json['fullname'] as String,
      id_nik: json['id_nik'].toString() as String,
      foto: json['foto'] as String,
      id_mbp: json['id_mbp'] as int,
      mbp_name: json['mbp_name'] as String,
      id_cluster: json['id_cluster'] as int,
      cluster_name: json['cluster_name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    "username": username,
    "password": password,
    "status": status,
    "fullname": fullname,
    "id_nik": id_nik,
    "foto": foto,
    "id_mbp": id_mbp,
    "mbp_name": mbp_name,
    "id_cluster": id_cluster,
    "cluster_name": cluster_name,
  };

  Map<String, dynamic> toMapLogin() => {
    "username": username,
    "password": password,
  };

  Map changeMapLogin() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;

    return map;
  }

  Map changeMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    map["status"] = status;
    map["fullname"] = fullname;
    map["id_nik"] = id_nik;
    map["foto"] = foto;
    map["id_mbp"] = id_mbp;
    map["mbp_name"] = mbp_name;
    map["id_cluster"] = id_cluster;
    map["cluster_name"] = cluster_name;

    return map;
  }
}