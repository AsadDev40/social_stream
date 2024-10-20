// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:channelhub/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildOnboardingPage(
                animation: 'assets/rive/welcome_animation.riv',
                title: 'Welcome to Social-Stream',
                description:
                    'Promote your Telegram and WhatsApp channels easily and effectively.',
              ),
              _buildOnboardingPage(
                animation: 'assets/rive/audience_animation.riv',
                title: 'Grow Your Audience',
                description:
                    'Reach a wider audience and increase your channel\'s visibility.',
              ),
              _buildOnboardingPage(
                animation: 'assets/rive/premium_animation.riv',
                title: 'Go Premium',
                description:
                    'Enjoy an ad-free experience and get unlimited promotions with our premium plan.',
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  child: const Text('SKIP'),
                ),
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            _currentIndex == index ? Colors.black : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                TextButton(
                  onPressed: () async {
                    if (_currentIndex == 2) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('seenOnboarding', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Homescreen(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(_currentIndex == 2 ? 'GET STARTED' : 'NEXT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String animation,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: RiveAnimation.asset(animation),
        ),
        const SizedBox(height: 50),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
