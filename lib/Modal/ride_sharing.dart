class RideSharing {
  int? status;
  Null? data;
  String? message;
  bool? success;

  RideSharing({this.status, this.data, this.message, this.success});

  RideSharing.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}