import 'package:cutting_master/services/http_service.dart';
import 'package:cutting_master/ui/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List orders = [];
  List ordersDetails = [];

  // Private properties
  bool _isLoading = false;

  // Getter & Setter
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  HomeProvider();

  void refreshUI() {
    notifyListeners();
  }

  void initialize() async {
    isLoading = true;

    await getOrders();

    for (var order in orders) {
      addOrderDetails({
        'order': order,
        'comment': TextEditingController(),
        "planned_time": null,
      });
    }

    isLoading = false;
  }

  void addOrderDetails(Map orderDetail) {
    ordersDetails.add(orderDetail);
    notifyListeners();
  }

  Future<void> getOrders({String status = "active"}) async {
    var res = await HttpService.get(Api.order, param: {
      'status': status,
    });

    if (res['status'] == Result.success) {
      orders = res['data'];
      notifyListeners();
    }
  }

  Future<void> sendToConstructor(
    BuildContext context,
    Map ordersDetails,
  ) async {
    if (ordersDetails['planned_time'] == null) {
      CustomSnackbars(context).error("Iltimos, reja vaqtini tanlang");
      return;
    }

    if (ordersDetails['comment'].text.isEmpty) {
      CustomSnackbars(context).error("Iltimos, izohni kiriting");
      return;
    }

    isLoading = true;

    var res = await HttpService.post(Api.sendToConstructor, {
      'order_id': ordersDetails['order']['id'],
      "planned_time": ordersDetails['planned_time'].toString(),
      "comment": ordersDetails['comment'].text,
    });

    isLoading = false;

    if (res['status'] == Result.success) {
      CustomSnackbars(context).success("Order sent to constructor");

      initialize();
    } else {
      CustomSnackbars(context).error("Failed to send order to constructor");
    }
  }
}
