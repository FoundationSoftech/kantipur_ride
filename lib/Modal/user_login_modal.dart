class UserLoginModal {
  int? status;
  Data? data;
  String? message;
  bool? success;

  UserLoginModal({this.status, this.data, this.message, this.success});

  UserLoginModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

class Data {
  String? token;
  UserData? userData;

  Data({this.token, this.userData});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? userId;
  String? mobileNumber;
  String? email;
  String? name;
  String? role;
  Null? currentLatitude;
  Null? currentLongitude;
  Null? socketId;
  bool? isVerified;
  bool? isActive;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.userId,
        this.mobileNumber,
        this.email,
        this.name,
        this.role,
        this.currentLatitude,
        this.currentLongitude,
        this.socketId,
        this.isVerified,
        this.isActive,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    name = json['name'];
    role = json['role'];
    currentLatitude = json['currentLatitude'];
    currentLongitude = json['currentLongitude'];
    socketId = json['socketId'];
    isVerified = json['isVerified'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['name'] = this.name;
    data['role'] = this.role;
    data['currentLatitude'] = this.currentLatitude;
    data['currentLongitude'] = this.currentLongitude;
    data['socketId'] = this.socketId;
    data['isVerified'] = this.isVerified;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}