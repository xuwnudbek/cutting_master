import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/pages/auth/auth_page.dart';
import 'package:cutting_master/ui/pages/cutting/cutting_page.dart';
import 'package:cutting_master/ui/pages/home/home_page.dart';
import 'package:cutting_master/ui/pages/main/main_page.dart';
import 'package:cutting_master/ui/pages/printing/printing_page.dart';
import 'package:cutting_master/ui/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(value) {
    _currentIndex = value;
    notifyListeners();
  }

  List<Map> pages = [
    {
      "title": "Home",
      "icon": Icons.home_rounded,
      "page": const HomePage(),
    },
    {
      "title": "Printing",
      "icon": Icons.print_rounded,
      "page": const PrintingPage(),
    },
    {
      "title": "Cutting",
      "icon": Icons.cut_rounded,
      "page": const CuttingPage(),
    }
  ];

  bool _isLoading = false;

  Widget _page = SizedBox.shrink();

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Widget get page => _page;
  set page(Widget value) {
    _page = value;
    notifyListeners();
  }

  MainProvider();

  void initialize() async {
    page = const SplashPage();

    await Future.delayed(const Duration(seconds: 2));

    String token = StorageService.read("token") ?? "";
    Map user = StorageService.read("user") ?? {};

    if (token.isNotEmpty && user.isNotEmpty) {
      page = const MainPage();
    } else {
      page = const AuthPage();
    }
  }
}
