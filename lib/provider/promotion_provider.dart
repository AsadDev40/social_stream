import 'package:channelhub/model/promotion_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionProvider extends ChangeNotifier {
  //Add Promotions
  Future<void> addPromotion(
      PromotionModel promotionmodel, String userId) async {
    await FirebaseFirestore.instance
        .collection('users/$userId/promotions')
        .add(promotionmodel.toMap());
    notifyListeners();
  }

  //Fetch user promotions
  Future<List<PromotionModel>> fetchPromotions(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users/$userId/promotions')
        .get();

    return snapshot.docs.map((doc) {
      return PromotionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
