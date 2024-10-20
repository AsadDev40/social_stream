// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:channelhub/model/promotion_model.dart';
import 'package:channelhub/pages/login_page.dart';
import 'package:channelhub/provider/promotion_provider.dart';
import 'package:channelhub/provider/subscription_provider.dart';
import 'package:channelhub/services/purchase_handler.dart';
import 'package:channelhub/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchases_paywall_ui/in_app_purchases_paywall_ui.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_promotion_screen.dart';
import 'profile_screen.dart';
import 'promotion_detail_screen.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  PurchaseHandler purchaseHandler = PurchaseHandler();
  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    Future<void> refreshPromotions() async {
      final promotionProvider =
          Provider.of<PromotionProvider>(context, listen: false);
      await promotionProvider.fetchPromotions(userId!);
    }

    void showPaywall(BuildContext context) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaywallScaffold(
          appBarTitle: 'Subscribe to Continue',
          child: Column(
            children: [
              Expanded(
                child: SimplePaywall(
                  headerContainer: Container(
                      margin: EdgeInsets.all(16),
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.center,
                              image: AssetImage('assets/premium_bg.png')))),
                  title: 'Unlimited Promotions',
                  subTitle:
                      'Choose a subscription plan to add unlimited promotions. You will get a 3-day free trial.',
                  bulletPoints: [
                    IconAndText(Icons.stop_screen_share_outlined, "No Ads"),
                    IconAndText(Icons.sort, "Unlimited Promotions"),
                  ],
                  subscriptionListData: [
                    SubscriptionData(
                      durationTitle: '7 Days',
                      durationShort: '7D',
                      price: '\$10',
                      rawPrice: 10.0,
                      currencySymbol: '\$',
                      duration: 'P1W',
                      monthText: 'week',
                      highlightText: 'Best Value',
                      dealPercentage: 0,
                      index: 0,
                      productDetails: 'basic_plan',
                    ),
                    SubscriptionData(
                      durationTitle: '3 Months',
                      durationShort: '3M',
                      price: '\$20',
                      rawPrice: 20.0,
                      currencySymbol: '\$',
                      duration: 'P3M',
                      monthText: 'month',
                      highlightText: 'Most Popular',
                      dealPercentage: 0,
                      index: 1,
                      productDetails: 'standard_plan',
                    ),
                    SubscriptionData(
                      durationTitle: '1 Year',
                      durationShort: '1Y',
                      price: '\$40',
                      rawPrice: 40.0,
                      currencySymbol: '\$',
                      duration: 'P1Y',
                      monthText: 'year',
                      highlightText: 'Best Deal',
                      dealPercentage: 0,
                      index: 2,
                      productDetails: 'premium_plan',
                    ),
                  ],
                  activePlanList: [
                    GooglePlayGeneralActivePlan(),
                    AppleAppStoreActivePlan(),
                  ],
                  isSubscriptionLoading: false,
                  isPurchaseInProgress: false,
                  purchaseState: PurchaseState.PURCHASED,
                  callbackInterface: purchaseHandler,
                  purchaseStateStreamInterface: purchaseHandler,
                  // successTitle: 'Successfully subscribed',
                  // successSubTitle: 'Thanks for Subscribe',
                ),
              ),
            ],
          ),
        ),
      ));
    }

    Future<void> checkSubscription(BuildContext context) async {
      final subscriptionProvider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      bool isSubscribed = await subscriptionProvider.isSubscribed(userId!);
      if (!isSubscribed) {
        showPaywall(context);
      } else {
        Utils.navigateTo(context, const AddPromotionScreen());
      }
    }

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Promotions'),
        ),
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please sign in to view promotions.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(const Size(80, 40)),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      alignment: Alignment.center),
                  onPressed: () {
                    Utils.navigateTo(context, const LoginPage());
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    final promotionProvider = Provider.of<PromotionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Promotions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
                onPressed: () {
                  Utils.navigateTo(context, const Profilescreen());
                },
                child: const Text(
                  'Profile',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshPromotions,
        child: FutureBuilder<List<PromotionModel>>(
          future: promotionProvider.fetchPromotions(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading promotions'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No promotions found'));
            }

            final promotions = snapshot.data!;
            return ListView.builder(
              itemCount: promotions.length,
              itemBuilder: (context, index) {
                final promotion = promotions[index];
                return ListTile(
                  title: Text('Channel Name: ${promotion.channelname}'),
                  subtitle: Text('Status: ${promotion.status}'),
                  onTap: () {
                    Utils.navigateTo(context,
                        PromotionRequestDetailScreen(promotion: promotion));
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await checkSubscription(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
