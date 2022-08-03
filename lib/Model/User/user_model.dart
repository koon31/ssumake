import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class User with ChangeNotifier{
  UserModel? user;

  login(UserModel userModel){
    if (user == null) {
      user = userModel;
    } else {
      if(userModel.id != null && userModel.id!.isNotEmpty) user?.id = userModel.id;
      if(userModel.personalId != null && userModel.personalId!.isNotEmpty) user?.personalId = userModel.personalId;
      if(userModel.email != null && userModel.email!.isNotEmpty) user?.email = userModel.email;
      if(userModel.phoneNumber != null && userModel.phoneNumber!.isNotEmpty) user?.phoneNumber = userModel.phoneNumber;
      user?.gender = userModel.gender;
      if(userModel.address != null && userModel.address!.isNotEmpty) user?.address = userModel.address;
      if(userModel.cwtId != null && userModel.cwtId!=0) user?.cwtId = userModel.cwtId;
      if(userModel.fullname != null && userModel.fullname!.isNotEmpty) user?.fullname = userModel.fullname;
      if(userModel.token != null && userModel.token!.isNotEmpty) user?.token = userModel.token;
    }
    notifyListeners();
  }

  logout() {
    user = null;
    notifyListeners();
  }

}

class UserModel {
  String? id;
  DateTime? dateofbirth;
  String? personalId;
  String? email;
  String? phoneNumber;
  int? gender;
  String? address;
  int? cwtId;
  String? fullname;
  String? token;

  UserModel({
    required this.id,
    required this.dateofbirth,
    required this.personalId,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.address,
    required this.cwtId,
    required this.fullname,
    required this.token,
  });

  UserModel.empty() {
    id = '';
    dateofbirth = DateTime.now();
    personalId = '';
    email = '';
    phoneNumber = '';
    gender = 1;
    address = '';
    cwtId = 0;
    fullname = '';
    token = '';
  }

  UserModel copyWith({
    String? id,
    DateTime? dateofbirth,
    String? personalId,
    String? email,
    String? phoneNumber,
    int? gender,
    String? address,
    int? cwtId,
    String? fullname,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      dateofbirth: dateofbirth ?? this.dateofbirth,
      personalId: personalId ?? this.personalId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      cwtId: cwtId ?? this.cwtId,
      fullname: fullname ?? this.fullname,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'dateofbirth': dateofbirth});
    result.addAll({'personalId': personalId});
    result.addAll({'email': email});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'gender': gender});
    result.addAll({'address': address});
    result.addAll({'cwtId': cwtId});
    result.addAll({'fullname': fullname});
    result.addAll({'token': token});
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime dbo = DateFormat('dd/MM/yyyy').parse(map['dateofbirth'].toString().substring(8, 10)+'/'+map['dateofbirth'].toString().substring(5, 7)+'/'+map['dateofbirth'].toString().substring(0, 4));
    return UserModel(
      id: map['id'] ?? '',
      dateofbirth: map['dateofbirth']!='' ? dbo : DateTime.now(),
      personalId: map['personalId'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phonenumber'] ?? '',
      gender: map['gender'] ? 1 : 0,
      address: map['address'] ?? '',
      cwtId: map['cwtId'] ?? 0,
      fullname: map['fullname'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, dateofbirth: $dateofbirth, personalId: $personalId, email: $email, phoneNumber: $phoneNumber, gender: $gender, address: $address, cwtId: $cwtId, fullname: $fullname, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.dateofbirth == dateofbirth &&
        other.id == id &&
        other.personalId == personalId &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.address == address &&
        other.cwtId == cwtId &&
        other.fullname == fullname &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    dateofbirth.hashCode ^
    personalId.hashCode ^
    email.hashCode ^
    phoneNumber.hashCode ^
    gender.hashCode ^
    address.hashCode ^
    cwtId.hashCode ^
    fullname.hashCode ^
    token.hashCode;
  }
}
