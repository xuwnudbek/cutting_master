import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/pages/auth/auth_page.dart';
import 'package:cutting_master/ui/pages/cutting/cutting_page.dart';
import 'package:cutting_master/ui/pages/home/home_page.dart';
import 'package:cutting_master/ui/pages/main/main_page.dart';
import 'package:cutting_master/ui/pages/printing/printing_page.dart';
import 'package:cutting_master/ui/pages/splash/splash_page.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';

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

  Future<bool> logout(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chiqish"),
          content: const Text("Rosdan ham dasturdan chiqishni hohlaysizmi?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.transparent,
                foregroundColor: AppColors.dark,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Bekor qilish"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.danger.withValues(alpha: 0.1),
                foregroundColor: AppColors.danger,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Text("Ha, albatta"),
              ),
            ),
          ],
        );
      },
    );

    if (res == true) {
      StorageService.clear();
      return res;
    }

    return false;
  }
}
