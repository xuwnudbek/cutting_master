import 'package:cutting_master/services/http_service.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/widgets/custom_snackbars.dart';
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

    await getOrder();

    isLoading = false;
  }

  Future<void> getOrder() async {
    int orderId = StorageService.read('order_id') ?? 0;

    var res = await HttpService.get("${Api.order}/$orderId");

    if (res['status'] == Result.success) {
      order = res['data'];
      orderOutcomes = order['outcomes'] ?? [];
      orderPrintingTime = order['orderPrintingTime'] ?? {};
    }
  }

  Future<bool> updateOrderStatus(String status) async {
    int orderId = StorageService.read('order_id') ?? 0;

    var res = await HttpService.put("${Api.order}/$orderId", {
      'status': status,
    });

    if (res['status'] == Result.success) {
      order = res['data'];
      return true;
    }

    return false;
  }

  Future<bool> acceptOrCancelCompletedItem(
    int outcomeId,
    String status,
    BuildContext context,
  ) async {
    var res = await HttpService.post(Api.completedItem, {
      "id": outcomeId,
      "status": status,
    });

    if (res['status'] == Result.success) {
      initialize();
      return true;
    } else {
      CustomSnackbars(context).error(res['data']?['error'] ?? "Error");
      return false;
    }
  }
}
