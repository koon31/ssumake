import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class RegisterUserModel with ChangeNotifier {
  String? password;
  DateTime? dateofbirth;
  String? phoneNumber;
  int? gender;
  String? fullname;

  RegisterUserModel({
    required this.password,
    required this.dateofbirth,
   required this.phoneNumber,
    required this.gender,
    required this.fullname,
  });

  RegisterUserModel.empty() {
    password = '';
    dateofbirth = DateTime.now();
    phoneNumber = '';
    gender = 1;
    fullname = '';
  }

  RegisterUserModel copyWith({
    String? password,
    DateTime? dateofbirth,
    String? phoneNumber,
    int? gender,
    String? fullname,
  }) {
    return RegisterUserModel(
      password: password ?? this.password,
      dateofbirth: dateofbirth ?? this.dateofbirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      fullname: fullname ?? this.fullname,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'password': password});
    result.addAll({'dayOfBirth': dateofbirth});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'gender': gender});
    result.addAll({'fullname': fullname});
    return result;
  }

  factory RegisterUserModel.fromMap(Map<String, dynamic> map) {
    DateTime dbo = DateFormat('dd/MM/yyyy').parse(map['dayOfBirth'].toString().substring(5, 7)+'/'+map['dayOfBirth'].toString().substring(8, 10)+'/'+map['dayOfBirth'].toString().substring(0, 4));
    return RegisterUserModel(
      password: map['password'] ?? '',
      dateofbirth: map['dayOfBirth']!='' ? dbo : DateTime.now(),
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] ? 1 : 0,
      fullname: map['fullname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterUserModel.fromJson(String source) =>
      RegisterUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'password: $password, dayOfBirth: $dateofbirth, phoneNumber: $phoneNumber, gender: $gender, fullname: $fullname)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterUserModel &&
        other.password == password &&
        other.dateofbirth == dateofbirth &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.fullname == fullname;
  }

  @override
  int get hashCode {
    return password.hashCode ^
    dateofbirth.hashCode ^
    phoneNumber.hashCode ^
    gender.hashCode ^
    fullname.hashCode;
  }
}
