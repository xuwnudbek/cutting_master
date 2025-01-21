import 'package:cutting_master/services/http_service.dart';
import 'package:flutter/material.dart';

class PrintingProvider extends ChangeNotifier {
  List orders = [];

  // Private properties
  bool _isLoading = false;

  // Getter & Setter
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  PrintingProvider();

  void refreshUI() {
    notifyListeners();
  }

  void initialize() async {
    isLoading = true;

    await getOrders();

    isLoading = false;
  }

  Future<void> getOrders() async {
    var res = await HttpService.get(Api.order, param: {
      'status': "printing",
    });

    if (res['status'] == Result.success) {
      orders = res['data'];
      notifyListeners();
    }
  }
}
