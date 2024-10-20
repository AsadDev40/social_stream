// ignore_for_file: prefer_final_fields

import 'package:channelhub/model/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SubscriptionModel> _subscriptions = [];

  List<SubscriptionModel> get subscriptions => _subscriptions;
// Check for subscription
  Future<bool> isSubscribed(String userId) async {
    final userSubscriptions = await _firestore
        .collection('users')
        .doc(userId)
        .collection('subscriptions')
        .where('isActive', isEqualTo: true)
        .get();
    return userSubscriptions.docs.isNotEmpty;
  }

// add subscription
  Future<void> addSubscription(String userId, String planId) async {
    if (await isSubscribed(userId)) {
      throw Exception('User is already subscribed.');
    }

    await _confirmSubscription(userId, planId);
  }

//Confirm subscription
  Future<void> _confirmSubscription(String userId, String planId) async {
    DateTime now = DateTime.now();
    DateTime trialEndDate = now.add(const Duration(days: 3));
    DateTime subscriptionEndDate;

    switch (planId) {
      case 'basic_plan':
        subscriptionEndDate = trialEndDate.add(const Duration(days: 7));
        break;
      case 'standard_plan':
        subscriptionEndDate = trialEndDate.add(const Duration(days: 90));
        break;
      case 'premium_plan':
        subscriptionEndDate = trialEndDate.add(const Duration(days: 365));
        break;
      default:
        throw Exception('Unknown plan ID');
    }

    SubscriptionModel newSubscription = SubscriptionModel(
      planName: planId,
      startDate: now,
      endDate: subscriptionEndDate,
      isActive: true,
      isTrial: true,
      removeAds: true,
    );

    DocumentReference<Map<String, dynamic>> userDocRef =
        _firestore.collection('users').doc(userId);

    CollectionReference<Map<String, dynamic>> userSubscriptions =
        userDocRef.collection('subscriptions');

    DocumentReference<Map<String, dynamic>> docRef =
        await userSubscriptions.add(newSubscription.toJson());

    // Fetch the subscription with the generated ID
    DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
    newSubscription = SubscriptionModel.fromJson(snapshot.data()!);
    _subscriptions.add(newSubscription);

    // Update the user's issubscribed field
    await userDocRef.update({'issubscribed': true});

    notifyListeners();
  }
}
