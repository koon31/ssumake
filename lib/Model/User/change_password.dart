import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ChangePasswordModel with ChangeNotifier {
  String? phonenumber;
  String? newPassword;
  String? oldPassword;

  ChangePasswordModel({
    required this.phonenumber,
    required this.newPassword,
    required this.oldPassword,
  });

  ChangePasswordModel.empty() {
    phonenumber = '';
    newPassword = '';
    oldPassword = '';
  }

  ChangePasswordModel copyWith({
    String? phonenumber,
    String? newPassword,
    String? oldPassword,
  }) {
    return ChangePasswordModel(
      phonenumber: phonenumber ?? this.phonenumber,
      newPassword: newPassword ?? this.newPassword,
      oldPassword: oldPassword ?? this.oldPassword,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'phonenumber': phonenumber});
    result.addAll({'newPassword': newPassword});
    result.addAll({'oldPassword': oldPassword});
    return result;
  }

  factory ChangePasswordModel.fromMap(Map<String, dynamic> map) {
    return ChangePasswordModel(
      phonenumber: map['phonenumber'] ?? '',
      newPassword: map['newPassword'] ?? '',
      oldPassword: map['oldPassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePasswordModel.fromJson(String source) =>
      ChangePasswordModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'phonenumber:$phonenumber, newPassword: $newPassword, oldPassword: $oldPassword)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangePasswordModel &&
        other.phonenumber == phonenumber &&
        other.newPassword == newPassword &&
        other.oldPassword == oldPassword;
  }

  @override
  int get hashCode {
    return phonenumber.hashCode ^
    newPassword.hashCode ^
    oldPassword.hashCode;
  }
}
