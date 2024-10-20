class SubscriptionModel {
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isTrial;
  final bool removeAds;

  SubscriptionModel({
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isTrial,
    required this.removeAds,
  });

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'isTrial': isTrial,
      'removeAds': removeAds,
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      planName: json['planName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      isTrial: json['isTrial'],
      removeAds: json['removeAds'],
    );
  }
}
