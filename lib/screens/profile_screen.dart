// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:channelhub/model/promotion_model.dart';
import 'package:channelhub/model/user_model.dart';
import 'package:channelhub/pages/sign_up_page.dart';
import 'package:channelhub/provider/auth_provider.dart' as authpro;
import 'package:channelhub/provider/promotion_provider.dart';
import 'package:channelhub/provider/subscription_provider.dart';
import 'package:channelhub/screens/edit_profile_screen.dart';
import 'package:channelhub/screens/home_screen.dart';
import 'package:channelhub/screens/promotion_detail_screen.dart';
import 'package:channelhub/utils/utils.dart';
import 'package:channelhub/widgets/add_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    checkSubscriptionStatus();
  }

  void checkSubscriptionStatus() async {
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    bool isSubscribed = await subscriptionProvider.isSubscribed(userId);
    setState(() {
      _isSubscribed = isSubscribed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<authpro.AuthProvider>(context);
    final promotionProvider = Provider.of<PromotionProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("You don't have an account yet. Please sign up"),
              ElevatedButton(
                onPressed: () {
                  Utils.navigateTo(context, const SignupPage());
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Center(
        child: FutureBuilder<UserModel>(
          future: authProvider.getUserFromFirestore(currentUserId),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 29),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        user.profileImage ?? 'https://via.placeholder.com/300'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.userName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                              WidgetStateProperty.all(const Size(150, 40)),
                          alignment: Alignment.center,
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      onPressed: () {
                        Utils.navigateTo(
                            context,
                            EditProfilePage(
                                imagepath: user.profileImage.toString(),
                                username: user.userName,
                                email: user.email,
                                userid: currentUserId));
                      },
                      child: const Text('Edit Profile',
                          style: TextStyle(color: Colors.black))),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                              WidgetStateProperty.all(const Size(150, 40)),
                          alignment: Alignment.center,
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      onPressed: () async {
                        await authProvider.addUserToFirestore(user);
                        Utils.pushAndRemovePrevious(
                            context, const Homescreen());
                      },
                      child: const Text('Delete Account',
                          style: TextStyle(color: Colors.black))),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            WidgetStateProperty.all(const Size(150, 40)),
                        alignment: Alignment.center,
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        await authProvider.logout();
                        Utils.pushAndRemovePrevious(
                            context, const Homescreen());
                      },
                      child: const Text('Logout',
                          style: TextStyle(color: Colors.black))),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!_isSubscribed) const AdBanner(),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Promotions',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: FutureBuilder<List<PromotionModel>>(
                      future: promotionProvider.fetchPromotions(currentUserId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading promotions'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No promotions found'));
                        }

                        final promotions = snapshot.data!;
                        return ListView.builder(
                          itemCount: promotions.length,
                          itemBuilder: (context, index) {
                            final promotion = promotions[index];
                            PromotionModel tappedPromotion = PromotionModel(
                                category: promotion.category,
                                id: promotion.id,
                                channelname: promotion.channelname,
                                description: promotion.description,
                                link: promotion.link,
                                status: promotion.status,
                                type: promotion.type);
                            return ListTile(
                              title: Text(
                                  'Channel Name: ${promotion.channelname}'),
                              subtitle: Text('Status: ${promotion.status}'),
                              onTap: () {
                                Utils.navigateTo(
                                    context,
                                    PromotionRequestDetailScreen(
                                        promotion: tappedPromotion));
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
