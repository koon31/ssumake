import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ChangeEmailUserModel with ChangeNotifier {
  String? emailOrPhoneChange;
  String? codeVerify;
  String? phoneNumber;

  ChangeEmailUserModel({
    required this.emailOrPhoneChange,
    required this.codeVerify,
    required this.phoneNumber,
  });

  ChangeEmailUserModel.empty() {
    emailOrPhoneChange = '';
    codeVerify = '';
    phoneNumber = '';
  }

  ChangeEmailUserModel copyWith({
    String? emailOrPhoneChange,
    String? codeVerify,
    String? phoneNumber,
  }) {
    return ChangeEmailUserModel(
      emailOrPhoneChange: emailOrPhoneChange ?? this.emailOrPhoneChange,
      codeVerify: codeVerify ?? this.codeVerify,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'emailOrPhoneChange': emailOrPhoneChange});
    result.addAll({'codeVerify': codeVerify});
    result.addAll({'phoneNumber': phoneNumber});
    return result;
  }

  factory ChangeEmailUserModel.fromMap(Map<String, dynamic> map) {
    return ChangeEmailUserModel(
      emailOrPhoneChange: map['emailOrPhoneChange'] ?? '',
      codeVerify: map['codeVerify'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeEmailUserModel.fromJson(String source) =>
      ChangeEmailUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'emailOrPhoneChange:$emailOrPhoneChange, codeVerify: $codeVerify, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangeEmailUserModel &&
        other.emailOrPhoneChange == emailOrPhoneChange &&
        other.codeVerify == codeVerify &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return emailOrPhoneChange.hashCode ^
    codeVerify.hashCode ^
    phoneNumber.hashCode;
  }
}
