class PromotionModel {
  final String id;
  final String channelname;
  final String description;
  final String link;
  final String type;
  final String category;
  final String? status;
  final String? categoryId;

  PromotionModel(
      {required this.id,
      required this.channelname,
      required this.description,
      required this.link,
      required this.type,
      required this.category,
      this.status,
      this.categoryId});

  factory PromotionModel.fromMap(Map<String, dynamic> data, String documentId) {
    return PromotionModel(
      id: documentId,
      channelname: data['channelname'] ?? '',
      description: data['description'] ?? '',
      link: data['link'] ?? '',
      type: data['type'] ?? '',
      category: data['category'] ?? '',
      status: data['status'],
      categoryId: data['categoryId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channelname': channelname,
      'description': description,
      'link': link,
      'type': type,
      'category': category,
      'status': status,
      'categoryId': categoryId
    };
  }
}
