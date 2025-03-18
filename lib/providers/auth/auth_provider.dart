import 'package:cutting_master/services/http_service.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthProvider();

  Future<bool> onLogin(BuildContext context) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackbars(context).warning('Iltimos, barcha maydonlarni to\'ldiring!');
      return false;
    }

    isLoading = true;

    bool result = false;

    await HttpService.post(
      Api.login,
      {
        "username": usernameController.text,
        "password": passwordController.text,
      },
      isAuth: true,
    ).then((res) {
      if (res['status'] == Result.success) {
        StorageService.write("token", res['data']['token']);
        StorageService.write("user", res['data']['user']);

        CustomSnackbars(context).success('Bichuvga xush kelibsiz!');

        result = true;
      } else {
        CustomSnackbars(context).error('Parol yoki login xato!');
      }
    });

    isLoading = false;

    return result;
  }
}
