import 'package:channelhub/model/promotion_model.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.issubscribed,
    this.profileImage,
    List<PromotionModel>? promotions,
  }) : promotions = promotions ?? [];

  final String uid;
  final String userName;
  final String email;
  final String? profileImage;
  final bool issubscribed;
  final List<PromotionModel> promotions;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      userName: json['userName'],
      email: json['email'],
      profileImage: json['profileImage'],
      issubscribed: json['issubscribed'],
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((p) => PromotionModel.fromMap(p, json['id']))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userName': userName,
        'email': email,
        'profileImage': profileImage,
        'issubscribed': issubscribed,
        'promotions': promotions.map((p) => p.toMap()).toList(),
      };
}
