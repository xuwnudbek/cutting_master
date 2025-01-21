import 'package:cutting_master/providers/main/main_provider.dart';
import 'package:cutting_master/ui/pages/splash/splash_page.dart';
import 'package:cutting_master/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  await GetStorage.init("cutting_master");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (context) => MainProvider()..initialize(),
      builder: (context, _) {
        return Consumer<MainProvider>(
          builder: (context, provider, _) {
            return GetMaterialApp(
              title: 'Cutting Master',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              home: provider.page,
            );
          },
        );
      },
    );
  }
}
