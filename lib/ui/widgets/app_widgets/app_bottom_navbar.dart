import 'package:cutting_master/providers/main/main_provider.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:provider/provider.dart';

class AppBottomNavbar extends StatelessWidget {
  const AppBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, provider, _) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          provider.currentIndex = index;
        },
        currentIndex: provider.currentIndex,
        items: [
          ...provider.pages.map((page) {
            return BottomNavigationBarItem(
              icon: Icon(page['icon']),
              label: page['title'],
            );
          }),
        ],
      );
    });
  }
}
