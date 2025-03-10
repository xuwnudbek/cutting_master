import 'package:cutting_master/providers/cutting/cutting_provider.dart';
import 'package:cutting_master/providers/home/home_provider.dart';
import 'package:cutting_master/providers/main/main_provider.dart';
import 'package:cutting_master/providers/printing/printing_provider.dart';
import 'package:cutting_master/ui/widgets/app_widgets/app_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, provider, _) {
        Map page = provider.pages[provider.currentIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text('${page['title']}'),
            actions: [
              IconButton(
                onPressed: () async {
                  var res = await provider.logout(context);

                  if (res == true) {
                    provider.initialize();
                  }
                },
                icon: Icon(
                  Icons.exit_to_app,
                ),
              ),
            ],
          ),
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider<HomeProvider>(
                create: (context) => HomeProvider()..initialize(),
              ),
              ChangeNotifierProvider<PrintingProvider>(
                create: (context) => PrintingProvider()..initialize(),
              ),
              ChangeNotifierProvider<CuttingProvider>(
                create: (context) => CuttingProvider()..initialize(),
              ),
            ],
            builder: (context, child) => page['page'],
          ),
          bottomNavigationBar: AppBottomNavbar(),
        );
      },
    );
  }
}
