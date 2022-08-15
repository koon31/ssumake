import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ForgotPasswordModel with ChangeNotifier {
  String? phonenumber;
  String? code;
  String? newPassword;

  ForgotPasswordModel({
    required this.phonenumber,
    required this.code,
    required this.newPassword,
  });

  ForgotPasswordModel.empty() {
    phonenumber = '';
    code = '';
    newPassword = '';
  }

  ForgotPasswordModel copyWith({
    String? phonenumber,
    String? code,
    String? newPassword,
  }) {
    return ForgotPasswordModel(
      phonenumber: phonenumber ?? this.phonenumber,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'phonenumber': phonenumber});
    result.addAll({'code': code});
    result.addAll({'newPassword': newPassword});
    return result;
  }

  factory ForgotPasswordModel.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordModel(
      phonenumber: map['phonenumber'] ?? '',
      code: map['code'] ?? '',
      newPassword: map['newPassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ForgotPasswordModel.fromJson(String source) =>
      ForgotPasswordModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'phonenumber:$phonenumber, code: $code, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ForgotPasswordModel &&
        other.phonenumber == phonenumber &&
        other.code == code &&
        other.newPassword == newPassword;
  }

  @override
  int get hashCode {
    return phonenumber.hashCode ^
    code.hashCode ^
    newPassword.hashCode;
  }
}
