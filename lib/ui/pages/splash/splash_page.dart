import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/pages/auth/auth_page.dart';
import 'package:cutting_master/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Scaffold(
      body: Center(
        child: Text(
          "Cutting Master",
          style: textTheme.titleMedium,
        ),
      ),
    );
  }
}
