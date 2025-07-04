import 'location_model.dart';

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? addressLane1;
  final String? addressLane2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? role;
  final bool isOnline;
  final bool isVerified;
  final bool isDeleted;
  final bool isDisabled;
  final String? profile;
  final String? referralCode;
  final String? plan;
  final String? previousPlan;
  final String? deletedMessage;
  final LocationModel? location;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.addressLane1,
    this.addressLane2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.role,
    required this.isOnline,
    required this.isVerified,
    required this.isDeleted,
    required this.isDisabled,
    this.profile,
    this.referralCode,
    this.plan,
    this.previousPlan,
    this.deletedMessage,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      addressLane1: json['addressLane1'],
      addressLane2: json['addressLane2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
      role: json['role'],
      isOnline: json['isOnline'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isDisabled: json['isDisabled'] ?? false,
      profile: json['profile'],
      referralCode: json['referralCode'],
      plan: json['plan'],
      previousPlan: json['previousPlan'],
      deletedMessage: json['deletedMessage'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }
}
