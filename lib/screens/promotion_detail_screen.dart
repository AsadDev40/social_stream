import 'package:channelhub/model/promotion_model.dart';
import 'package:channelhub/provider/subscription_provider.dart';
import 'package:channelhub/widgets/add_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromotionRequestDetailScreen extends StatefulWidget {
  final PromotionModel promotion;

  const PromotionRequestDetailScreen({super.key, required this.promotion});

  @override
  State<PromotionRequestDetailScreen> createState() =>
      _PromotionRequestDetailScreenState();
}

class _PromotionRequestDetailScreenState
    extends State<PromotionRequestDetailScreen> {
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    checksubscription();
  }

  void checksubscription() async {
    final subscriptionprovider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    bool isSubscribed = await subscriptionprovider.isSubscribed(userId);
    setState(() {
      _isSubscribed = isSubscribed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotion Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Promotion Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Channel Name: ${widget.promotion.channelname}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Description: ${widget.promotion.description}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Status: ${widget.promotion.status}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Category: ${widget.promotion.category}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Channel link: ${widget.promotion.link}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            if (!_isSubscribed) const AdBanner(),
          ],
        ),
      ),
    );
  }
}
