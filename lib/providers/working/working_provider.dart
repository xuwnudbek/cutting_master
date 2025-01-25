import 'dart:developer';

import 'package:cutting_master/services/http_service.dart';
import 'package:cutting_master/services/storage_service.dart';
import 'package:cutting_master/ui/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';

class WorkingProvider extends ChangeNotifier {
  Map orderData = {};
  Map model = {};
  List submodels = [];
  List specificationCategories = [];

  List cuts = [];

  TextEditingController specQuantityController = TextEditingController();

  bool _isLoading = false;
  Map _selectedSubmodel = {};
  Map _selectedSpecificationCategory = {};

  Map get selectedSubmodel => _selectedSubmodel;
  set selectedSubmodel(Map value) {
    _selectedSubmodel = value;
    notifyListeners();

    if (value.isNotEmpty) {
      selectedSpecificationCategory = {};
      specificationCategories = value['specificationCategories'];
    }
  }

  Map get selectedSpecificationCategory => _selectedSpecificationCategory;
  set selectedSpecificationCategory(Map value) {
    _selectedSpecificationCategory = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  WorkingProvider();

  void initialize() async {
    isLoading = true;

    await getOrder();
    await getCuts();

    inspect(orderData);

    isLoading = false;
  }

  Future<void> getOrder() async {
    int orderId = StorageService.read("order_id");

    var res = await HttpService.get("${Api.specifications}/$orderId");

    if (res['status'] == Result.success) {
      orderData = res['data'];
      model = orderData['orderModel']['model'];
      submodels = orderData['orderModel']['submodels'];
      selectedSubmodel = submodels.firstOrNull ?? {};
    }
  }

  Future<void> getCuts() async {
    int orderId = StorageService.read("order_id");

    var res = await HttpService.get("${Api.cuts}/$orderId");

    if (res['status'] == Result.success) {
      cuts = res['data'];
      notifyListeners();
    }
  }

  Future<void> markAsCut(BuildContext context) async {
    if (selectedSubmodel.isEmpty) {
      CustomSnackbars(context).error("Submodelni tanlang");
      return;
    }

    if (selectedSpecificationCategory.isEmpty) {
      CustomSnackbars(context).error("Specification categoryni tanlang");
      return;
    }

    if (specQuantityController.text.isEmpty) {
      CustomSnackbars(context).error("Miqdorni kiriting");
      return;
    }

    var res = await HttpService.post(Api.markAsCut, {
      "order_id": orderData['id'],
      "category_id": selectedSpecificationCategory['id'],
      "quantity": specQuantityController.text,
    });

    if (res['status'] == Result.success) {
      await getCuts();

      CustomSnackbars(context).success("Marked as cut");
      specQuantityController.clear();
      selectedSpecificationCategory = {};
    } else {
      CustomSnackbars(context).error("Failed to mark as cut");
    }
  }
}
