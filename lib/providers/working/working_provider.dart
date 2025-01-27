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
  bool _isSaving = false;
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

  bool get isSaving => _isSaving;
  set isSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  WorkingProvider();

  void initialize() async {
    isLoading = true;

    await getOrder();
    await getCuts();

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

  Future<Map?> markAsCut(BuildContext context) async {
    if (selectedSubmodel.isEmpty) {
      CustomSnackbars(context).error("Submodelni tanlang");
      return null;
    }

    if (selectedSpecificationCategory.isEmpty) {
      CustomSnackbars(context).error("Specification categoryni tanlang");
      return null;
    }

    if (specQuantityController.text.isEmpty) {
      CustomSnackbars(context).error("Miqdorni kiriting");
      return null;
    }

    inspect(orderData);

    Map<String, dynamic> data = {
      "order_id": orderData['id'],
      "category_id": selectedSpecificationCategory['id'],
      "quantity": specQuantityController.text,
    };

    var res = await HttpService.post(
      Api.markAsCut,
      data,
    );

    if (res['status'] == Result.success) {
      await getCuts();

      Map printData = {
        "order": orderData,
        "category": selectedSpecificationCategory,
        "quantity": specQuantityController.text,
      };

      CustomSnackbars(context).success("Kesilgan deb saqlandi!");
      specQuantityController.clear();
      selectedSpecificationCategory = {};

      return printData;
    } else {
      CustomSnackbars(context).error("Saqlashda xatolik yuz berdi!");
    }
  }
}
