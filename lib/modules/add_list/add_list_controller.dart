import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/drug_item_model.dart';
import '../../core/network/api_exception.dart';
import 'services/product_api.dart';

class AddListController extends GetxController {
  AddListController({ProductApi? api}) : _api = api ?? ProductApi();

  final ProductApi _api;

  /// SEARCH
  final searchCtrl = TextEditingController();
  final isSearching = false.obs;
  final isFetching = false.obs;

  /// FORM CONTROLLERS
  final saleCtrl = TextEditingController(); // discount_price
  final pSaleCtrl = TextEditingController(); // peak_hour_price
  final offerCtrl = TextEditingController(); // offer_price
  final maxQtyCtrl = TextEditingController(); // qty (int)

  final isSubmitting = false.obs;

  /// SELECTED
  final selectedProduct = Rxn<DrugItemModel>();

  /// RESULTS (from API)
  final filteredProducts = <DrugItemModel>[].obs;

  Timer? _debounce;

  void onSearchChanged(String value) {
    final q = value.trim();

    if (q.isEmpty) {
      _debounce?.cancel();
      isSearching.value = false;
      filteredProducts.clear();
      return;
    }

    isSearching.value = true;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      await _searchApi(q);
    });
  }

  Future<void> _searchApi(String query) async {
    isFetching.value = true;
    try {
      final items = await _api.searchProducts(query);
      filteredProducts.assignAll(items);
    } on ApiException catch (e) {
      filteredProducts.clear();
      Get.snackbar('Search Failed', e.message);
    } finally {
      isFetching.value = false;
    }
  }

  void selectProduct(DrugItemModel product) {
    selectedProduct.value = product;

    isSearching.value = false;
    filteredProducts.clear();
    searchCtrl.clear();

    // optional: clear form when selecting another product
    saleCtrl.clear();
    pSaleCtrl.clear();
    offerCtrl.clear();
    maxQtyCtrl.clear();
  }

  /// ✅ SUBMIT ADD STOCK
  Future<void> submitAddStock() async {
    final product = selectedProduct.value;
    if (product == null) {
      Get.snackbar('Select Product', 'Please select a product first.');
      return;
    }

    // Parse input
    final sale = num.tryParse(saleCtrl.text.trim());
    final pSale = num.tryParse(pSaleCtrl.text.trim());
    final offer = num.tryParse(offerCtrl.text.trim());
    final qty = int.tryParse(maxQtyCtrl.text.trim());

    if (sale == null || pSale == null || offer == null || qty == null) {
      Get.snackbar(
        'Invalid Input',
        'Please enter valid numbers in all fields.',
      );
      return;
    }

    // RULE: qty must be int and >= 0 (or >0 allowed)
    if (qty < 0) {
      Get.snackbar('Invalid Qty', 'Qty must be 0 or greater.');
      return;
    }

    // MRP from selected product
    final mrp = product.retailMaxPrice;
    if (mrp <= 0) {
      Get.snackbar('Invalid MRP', 'Selected product MRP is invalid.');
      return;
    }

    // RULES:
    // P-sale >= sale
    if (pSale < sale) {
      Get.snackbar(
        'Rule Failed',
        'P-sale must be greater than or equal to Sale.',
      );
      return;
    }

    // P-sale <= MRP
    if (pSale > mrp) {
      Get.snackbar('Rule Failed', 'P-sale must be less than or equal to MRP.');
      return;
    }

    // M-offer < sale and p-sale
    if (!(offer < sale && offer < pSale)) {
      Get.snackbar('Rule Failed', 'M-offer must be less than Sale and P-sale.');
      return;
    }

    isSubmitting.value = true;
    try {
      final req = AddUpdateItemRequest(
        productId: product.id,
        stockMrp: mrp,
        discountPrice: sale,
        peakHourPrice: pSale,
        offerPrice: offer,
        qty: qty,
      );

      final res = await _api.addOrUpdateProductList(req);

      Get.snackbar('Success', res.message);

      // Optional: clear form after success
      saleCtrl.clear();
      pSaleCtrl.clear();
      offerCtrl.clear();
      maxQtyCtrl.clear();
    } on ApiException catch (e) {
      Get.snackbar('Failed', e.message);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    saleCtrl.dispose();
    pSaleCtrl.dispose();
    offerCtrl.dispose();
    maxQtyCtrl.dispose();
    super.onClose();
  }
}
