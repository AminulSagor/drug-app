import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_exception.dart';
import '../add_list/services/product_api.dart';
import 'models/listed_item_model.dart';
import 'services/all_list_api.dart';
import 'widgets/edit_drug_dialog.dart';

enum SaleModeOption { sale, pSale }

enum EditAction { update, stockOut }

class AllListController extends GetxController {
  AllListController({AllListApi? api, ProductApi? productApi})
    : _api = api ?? AllListApi(),
      _productApi = productApi ?? ProductApi();

  final AllListApi _api;
  final ProductApi _productApi;

  /// UI
  final searchCtrl = TextEditingController();

  /// Loading
  final isLoading = false.obs;

  /// bill mode loading (dialog)
  final isBillModeLoading = false.obs;

  /// edit/update loading (dialog)
  final isEditLoading = false.obs;

  /// Data
  final items = <ListedItemModel>[].obs;

  /// Query
  final searchQuery = ''.obs;

  /// Pagination (from API)
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final perPage = 20.obs;
  final totalItems = 0.obs;
  final from = 0.obs;
  final to = 0.obs;

  int get totalPages => lastPage.value;
  int get showingFrom => from.value;
  int get showingTo => to.value;

  bool get isSearching => searchQuery.value.trim().isNotEmpty;

  /// ===== Bill Mode State =====
  final currentBillMode = RxnInt(); // 0/1
  final selectedSaleMode = SaleModeOption.sale.obs;

  /// ===================== EDIT STATE =====================
  final editSaleCtrl = TextEditingController();
  final editPSaleCtrl = TextEditingController();
  final editOfferCtrl = TextEditingController();
  final editQtyCtrl = TextEditingController();
  final editingItem = Rxn<ListedItemModel>();

  Timer? _searchDebounce;

  final editAction = Rxn<EditAction>(); // which button is loading

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCurrentBillMode();
      await fetchPage(page: 1);
    });
  }

  /// ===================== STOCK LIST =====================
  Future<void> fetchPage({required int page}) async {
    isLoading.value = true;
    try {
      final res = await _api.getAllCurrentStock(page: page);
      final cs = res.currentStock;

      items.assignAll(cs.data);

      currentPage.value = cs.currentPage;
      lastPage.value = cs.lastPage;
      perPage.value = cs.perPage;

      totalItems.value = cs.total;
      from.value = cs.from;
      to.value = cs.to;
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// ===================== SEARCH =====================
  void onSearchChanged(String v) {
    searchQuery.value = v;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
      await _searchNowOrPaginate();
    });
  }

  Future<void> _searchNowOrPaginate() async {
    final q = searchQuery.value.trim();

    if (q.isEmpty) {
      await fetchPage(page: 1);
      return;
    }

    isLoading.value = true;
    try {
      final results = await _api.searchCurrentProduct(query: q);
      items.assignAll(results);

      // fake pagination while searching
      currentPage.value = 1;
      lastPage.value = 1;
      perPage.value = results.length;
      totalItems.value = results.length;
      from.value = results.isEmpty ? 0 : 1;
      to.value = results.length;
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchCtrl.clear();
    searchQuery.value = '';
    fetchPage(page: 1);
  }

  /// ===================== PAGINATION =====================
  void nextPage() {
    if (isSearching) return;
    if (currentPage.value < totalPages) {
      fetchPage(page: currentPage.value + 1);
    }
  }

  void prevPage() {
    if (isSearching) return;
    if (currentPage.value > 1) {
      fetchPage(page: currentPage.value - 1);
    }
  }

  /// ===================== BILL MODE =====================
  Future<void> _loadCurrentBillMode() async {
    await _runBlocking(isBillModeLoading, () async {
      final res = await _api.getCurrentBillMode();
      final mode = res.billMode.billMode; // 0/1
      currentBillMode.value = mode;
      selectedSaleMode.value = (mode == 1)
          ? SaleModeOption.pSale
          : SaleModeOption.sale;
    });
  }

  Future<void> changeBillMode(SaleModeOption option) async {
    final next = (option == SaleModeOption.pSale) ? 1 : 0;
    if (currentBillMode.value == next) return;

    await _runBlocking(isBillModeLoading, () async {
      final res = await _api.updateBillMode(billMode: next);
      currentBillMode.value = next;
      selectedSaleMode.value = option;

      // ✅ refetch list again after bill mode update
      await _refreshCurrentList();

      if (res.message.trim().isNotEmpty) {
        Get.snackbar('Bill Mode', res.message);
      }
    });
  }

  /// ===================== EDIT / UPDATE STOCK =====================
  void onEditItem(ListedItemModel item) {
    editingItem.value = item;

    // prefill fields from current values
    editSaleCtrl.text = (item.currentStock?.discountPrice ?? 0).toString();
    editPSaleCtrl.text = (item.currentStock?.peakHourPrice ?? 0).toString();
    editOfferCtrl.text = (item.offer).toString();

    // NOTE: you didn't have qty in model; using stockAlert as best guess.
    editQtyCtrl.text = '${item.currentStock?.stockAlert ?? 0}';

    Get.dialog(const EditDrugDialog(), barrierDismissible: true);
  }

  Future<void> onPressUpdate() async {
    final item = editingItem.value;
    if (item == null) return;
    if (isEditLoading.value) return;

    final mrp = item.retailMaxPrice;
    final sale = _parseNum(editSaleCtrl.text);
    final pSale = _parseNum(editPSaleCtrl.text);
    final offer = _parseNum(editOfferCtrl.text);
    final qty = _parseInt(editQtyCtrl.text);

    if (sale == null || pSale == null || offer == null || qty == null) {
      Get.snackbar('Invalid', 'Please enter valid numbers in all fields.');
      return;
    }

    if (qty < 0) {
      Get.snackbar('Invalid', 'Qty must be 0 or greater.');
      return;
    }

    if (pSale < sale) {
      Get.snackbar('Invalid', 'P-sale must be greater than or equal to Sale.');
      return;
    }
    if (pSale > mrp) {
      Get.snackbar('Invalid', 'P-sale must be less than or equal to MRP.');
      return;
    }
    if (!(offer < sale && offer < pSale)) {
      Get.snackbar('Invalid', 'M-offer must be less than Sale and P-sale.');
      return;
    }

    editAction.value = EditAction.update;

    await _runBlocking(isEditLoading, () async {
      final res = await _productApi.addOrUpdateProductList(
        AddUpdateItemRequest(
          productId: item.id,
          stockMrp: item.retailMaxPrice,
          discountPrice: sale, // Sale UI -> discount_price
          peakHourPrice: pSale, // P-sale UI -> peak_hour_price
          offerPrice: offer, // M-offer UI -> offer_price
          qty: qty, // Max-Acpt QTY
        ),
      );

      if (Get.isDialogOpen == true) Get.back(); // close dialog
      await _refreshCurrentList();

      if (res.message.trim().isNotEmpty) {
        Get.snackbar('Success', res.message);
      }
    });

    editAction.value = null;
  }

  Future<void> onPressStockOut() async {
    final item = editingItem.value;
    if (item == null) return;
    if (isEditLoading.value) return;

    final sale =
        _parseNum(editSaleCtrl.text) ?? (item.currentStock?.discountPrice ?? 0);
    final pSale =
        _parseNum(editPSaleCtrl.text) ??
        (item.currentStock?.peakHourPrice ?? 0);
    final offer =
        _parseNum(editOfferCtrl.text) ??
        (item.currentStock?.mediboyOfferPrice ?? 0);

    final mrp = item.retailMaxPrice;

    if (pSale < sale) {
      Get.snackbar('Invalid', 'P-sale must be greater than or equal to Sale.');
      return;
    }
    if (pSale > mrp) {
      Get.snackbar('Invalid', 'P-sale must be less than or equal to MRP.');
      return;
    }
    if (!(offer < sale && offer < pSale)) {
      Get.snackbar('Invalid', 'M-offer must be less than Sale and P-sale.');
      return;
    }

    editAction.value = EditAction.stockOut;

    await _runBlocking(isEditLoading, () async {
      final res = await _productApi.addOrUpdateProductList(
        AddUpdateItemRequest(
          productId: item.id,
          stockMrp: item.retailMaxPrice,
          discountPrice: sale,
          peakHourPrice: pSale,
          offerPrice: offer,
          qty: 0, // ✅ stock-out
        ),
      );

      if (Get.isDialogOpen == true) Get.back(); // close dialog
      await _refreshCurrentList();

      if (res.message.trim().isNotEmpty) {
        Get.snackbar('Success', res.message);
      }
    });

    editAction.value = null;
  }

  Future<void> _refreshCurrentList() async {
    if (isSearching) {
      await _searchNowOrPaginate();
    } else {
      await fetchPage(page: currentPage.value);
    }
  }

  /// ===================== BLOCKING LOADER =====================
  Future<void> _runBlocking(RxBool guard, Future<void> Function() fn) async {
    if (guard.value) return;

    guard.value = true;
    try {
      await fn();
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      guard.value = false;
    }
  }

  num? _parseNum(String v) {
    final t = v.trim();
    if (t.isEmpty) return null;
    return num.tryParse(t);
  }

  int? _parseInt(String v) {
    final t = v.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();

    searchCtrl.dispose();
    editSaleCtrl.dispose();
    editPSaleCtrl.dispose();
    editOfferCtrl.dispose();
    editQtyCtrl.dispose();
    super.onClose();
  }
}
