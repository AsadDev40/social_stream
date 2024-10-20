import 'package:channelhub/screens/home_screen.dart';
import 'package:channelhub/screens/onboarding_screens.dart';
import 'package:channelhub/services/app_provider_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            primary: Colors.black,
            primaryContainer: Colors.white,
            seedColor: Colors.black54,
            brightness: Brightness.light,
          ),
        ),
        builder: EasyLoading.init(),
        home: seenOnboarding ? const Homescreen() : const OnboardingScreen(),
      ),
    );
  }
}
