// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:channelhub/model/channel_model.dart';
import 'package:channelhub/provider/channel_provider.dart';
import 'package:channelhub/provider/subscription_provider.dart';
import 'package:channelhub/widgets/add_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChannelDetailScreen extends StatefulWidget {
  final String categoryId;
  final String channelId;
  final String channelType;

  const ChannelDetailScreen({
    super.key,
    required this.categoryId,
    required this.channelId,
    required this.channelType,
  });

  @override
  _ChannelDetailScreenState createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  late Future<Channel> _channelFuture;
  RewardedAd? _rewardedAd;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    final channelProvider =
        Provider.of<ChannelProvider>(context, listen: false);
    _channelFuture = channelProvider.getChannelByIdSync(
      widget.categoryId,
      widget.channelId,
      widget.channelType,
    );
    _checkSubscriptionStatus();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/5224354917', // Replace with your actual Ad Unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd!.setImmersiveMode(true);
          _showRewardedAd();
        },
        onAdFailedToLoad: (error) {
          print('Failed to load a rewarded ad: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
        },
      );
      _rewardedAd = null;
    }
  }

  void _checkSubscriptionStatus() async {
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    bool isSubscribed = await subscriptionProvider.isSubscribed(userId);
    setState(() {
      _isSubscribed = isSubscribed;
    });

    if (!_isSubscribed) {
      _loadRewardedAd();
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Channel>(
              future: _channelFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No channel details found.'));
                }

                final channel = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Channel Name: ${channel.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description: ${channel.description}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Link: ${channel.link}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white)),
                        onPressed: () {
                          Provider.of<ChannelProvider>(context, listen: false)
                              .copyToClipboard(channel.link, context);
                        },
                        child: const Text('Copy Link'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (!_isSubscribed) const AdBanner(),
        ],
      ),
    );
  }
}
