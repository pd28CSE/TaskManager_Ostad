class AuthUserModel {
  String? status;
  String? token;
  UserData? data;

  AuthUserModel({this.status, this.token, this.data});

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['token'] = token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  UserData(
      {this.email, this.firstName, this.lastName, this.mobile, this.photo});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['photo'] = photo;

    return data;
  }
}
