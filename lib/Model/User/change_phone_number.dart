import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ChangePhoneNumberUserModel with ChangeNotifier {
  String? emailOrPhoneChange;
  String? codeVerify;
  String? phoneNumber;

  ChangePhoneNumberUserModel({
    required this.emailOrPhoneChange,
    required this.codeVerify,
    required this.phoneNumber,
  });

  ChangePhoneNumberUserModel.empty() {
    emailOrPhoneChange = '';
    codeVerify = '';
    phoneNumber = '';
  }

  ChangePhoneNumberUserModel copyWith({
    String? emailOrPhoneChange,
    String? codeVerify,
    String? phoneNumber,
  }) {
    return ChangePhoneNumberUserModel(
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

  factory ChangePhoneNumberUserModel.fromMap(Map<String, dynamic> map) {
    return ChangePhoneNumberUserModel(
      emailOrPhoneChange: map['emailOrPhoneChange'] ?? '',
      codeVerify: map['codeVerify'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePhoneNumberUserModel.fromJson(String source) =>
      ChangePhoneNumberUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'emailOrPhoneChange:$emailOrPhoneChange, codeVerify: $codeVerify, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangePhoneNumberUserModel &&
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
