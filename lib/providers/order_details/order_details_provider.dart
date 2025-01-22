import 'package:cutting_master/services/http_service.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:flutter/material.dart';

class OrderDetailsProvider extends ChangeNotifier {
  Map order = {};
  List orderOutcomes = [];
  Map orderPrintingTime = {};

  // Private variable
  bool _isLoading = false;

  // Getter and setter
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  OrderDetailsProvider();

  void initialize() async {
    isLoading = true;

    await getOrders();

    isLoading = false;
  }

  Future<void> getOrders() async {
    int orderId = StorageService.read('order_id') ?? 0;

    var res = await HttpService.get("${Api.order}/$orderId");

    if (res['status'] == Result.success) {
      order = res['data'];
      orderOutcomes = order['outcomes'] ?? [];
      orderPrintingTime = order['orderPrintingTime'] ?? {};
    }
  }
}
