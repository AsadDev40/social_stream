// ignore_for_file: avoid_print

import 'package:channelhub/provider/subscription_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';
import 'package:provider/provider.dart';

class PurchaseHandler extends DefaultPurchaseHandler {
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  Future<bool> purchase(SubscriptionData productDetails) async {
    print("purchase start");
    isPendingPurchase = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate purchase delay
    print("purchase done");
    purchaseState = PurchaseState.PURCHASED;
    isPendingPurchase = false;

    // Add subscription in Firestore
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    print('User id: $userId');

    if (userId != null && _context != null) {
      print('Purchased statrt');

      final subscriptionProvider = Provider.of<SubscriptionProvider>(
        _context!,
        listen: false,
      );
      print('Purchased pending');

      await subscriptionProvider.addSubscription(
          userId, productDetails.productDetails);
      print('Purchased successfully');
    }

    return true;
  }

  @override
  Future<bool> restore() async {
    isPendingPurchase = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate restore delay
    purchaseState = PurchaseState.PURCHASED;
    isPendingPurchase = false;
    return true;
  }
}
