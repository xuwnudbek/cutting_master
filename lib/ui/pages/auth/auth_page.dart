import 'package:cutting_master/providers/auth/auth_provider.dart';
import 'package:cutting_master/providers/main/main_provider.dart';
import 'package:cutting_master/ui/pages/home/home_page.dart';
import 'package:cutting_master/ui/widgets/custom_input.dart';
import 'package:cutting_master/utils/theme/app_colors.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Consumer<AuthProvider>(
            builder: (context, provider, _) {
              return Center(
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Kirish',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomInput(
                        controller: provider.usernameController,
                        hint: 'Username',
                      ),
                      const SizedBox(height: 8),
                      CustomInput(
                        controller: provider.passwordController,
                        hint: 'Parol',
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () async {
                          var res = await provider.onLogin(context);

                          if (res) {
                            context.read<MainProvider>().page = const HomePage();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: provider.isLoading
                              ? [
                                  SizedBox.square(
                                    dimension: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.light,
                                    ),
                                  )
                                ]
                              : [
                                  const Icon(
                                    Icons.login,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Kirish'),
                                ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
