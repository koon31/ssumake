import 'dart:convert';

class UpdateUserModel {
  String? customerId;
  String? address;
  int? gender;
  String? fullname;
  int? cwtId;

  UpdateUserModel({
    required this.customerId,
    required this.address,
    required this.gender,
    required this.fullname,
    required this.cwtId,
  });

  UpdateUserModel.empty() {
    customerId = '';
    address = '';
    gender = 1;
    fullname = '';
    cwtId = 0;
  }

  UpdateUserModel copyWith({
    String? customerId,
    String? address,
    int? gender,
    String? fullname,
    int? cwtId,
  }) {
    return UpdateUserModel(
      customerId: customerId ?? this.customerId,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      fullname: fullname ?? this.fullname,
      cwtId: cwtId ?? this.cwtId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'customerId': customerId});
    result.addAll({'address': address});
    result.addAll({'gender': gender});
    result.addAll({'fullname': fullname});
    result.addAll({'cwtId': cwtId});
    return result;
  }

  factory UpdateUserModel.fromMap(Map<String, dynamic> map) {
    return UpdateUserModel(
      customerId: map['customerId'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ? 1 : 0,
      fullname: map['fullname'] ?? '',
      cwtId: map['cwtId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserModel.fromJson(String source) =>
      UpdateUserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'customerId: $customerId, address: $address, gender: $gender, fullname: $fullname, cwtId: $cwtId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateUserModel &&
        other.customerId == customerId &&
        other.address == address &&
        other.gender == gender &&
        other.fullname == fullname &&
        other.cwtId == cwtId;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
    address.hashCode ^
    gender.hashCode ^
    fullname.hashCode ^
    cwtId.hashCode;
  }
}
