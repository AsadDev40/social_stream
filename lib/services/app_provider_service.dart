import 'package:channelhub/provider/auth_provider.dart';
import 'package:channelhub/provider/category_provider.dart';
import 'package:channelhub/provider/channel_provider.dart';
import 'package:channelhub/provider/file_upload_provider.dart';
import 'package:channelhub/provider/image_picker_provider.dart';
import 'package:channelhub/provider/promotion_provider.dart';
import 'package:channelhub/provider/subscription_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => ChannelProvider()),
          ChangeNotifierProvider(create: (context) => PromotionProvider()),
          ChangeNotifierProvider(create: (context) => FileUploadProvider()),
          ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ],
        child: child,
      );
}
