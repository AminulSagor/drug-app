import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/drug_item_model.dart';
import 'widgets/edit_drug_dialog.dart';

class AllListController extends GetxController {
  /// UI
  final searchCtrl = TextEditingController();

  /// Loading
  final isLoading = false.obs;

  /// Current page items ONLY
  final items = <DrugItemModel>[].obs;

  /// Query
  final searchQuery = ''.obs;

  /// Pagination
  final int pageSize = 20;
  final int totalItems = 49; // mock backend total
  final currentPage = 1.obs;

  int get totalPages => (totalItems / pageSize).ceil();

  int get showingFrom {
    if (items.isEmpty) return 0;
    return ((currentPage.value - 1) * pageSize) + 1;
  }

  int get showingTo {
    final to = currentPage.value * pageSize;
    return to > totalItems ? totalItems : to;
  }

  /// ===================== EDIT STATE =====================
  final editSaleCtrl = TextEditingController();
  final editPSaleCtrl = TextEditingController();
  final editOfferCtrl = TextEditingController();
  final editQtyCtrl = TextEditingController();

  final editingItem = Rxn<DrugItemModel>();

  /// ===================== INIT =====================
  @override
  void onInit() {
    super.onInit();
    fetchPage(page: 1);
  }

  /// ===================== MOCK API =====================
  Future<void> fetchPage({required int page}) async {
    isLoading.value = true;

    // simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize) > totalItems
        ? totalItems
        : (startIndex + pageSize);

    final List<DrugItemModel> pageData = [];

    for (int i = startIndex; i < endIndex; i++) {
      final base = _baseProducts[i % _baseProducts.length];

      pageData.add(
        base.copyWith(
          id: 'drug_${i + 1}',
          quantity: (i % 2 == 0) ? 0 : ((i % 5) + 3),
        ),
      );
    }

    items.assignAll(pageData);
    currentPage.value = page;
    isLoading.value = false;
  }

  /// ===================== SEARCH =====================
  void onSearchChanged(String v) {
    searchQuery.value = v;
    fetchPage(page: 1); // reset pagination on search
  }

  void clearSearch() {
    searchCtrl.clear();
    searchQuery.value = '';
    fetchPage(page: 1);
  }

  /// ===================== PAGINATION =====================
  void nextPage() {
    if (currentPage.value < totalPages) {
      fetchPage(page: currentPage.value + 1);
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      fetchPage(page: currentPage.value - 1);
    }
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    fetchPage(page: page);
  }

  /// ===================== ACTION =====================
  void onEditItem(DrugItemModel item) {
    editingItem.value = item;

    editSaleCtrl.text = item.sale.toString();
    editPSaleCtrl.text = item.pSale.toString();
    editOfferCtrl.text = item.offer.toString();
    editQtyCtrl.text = item.quantity.toString();

    Get.dialog(const EditDrugDialog(), barrierDismissible: true);
  }

  void markStockOut() {
    editQtyCtrl.text = '0';
  }

  void updateItem() {
    final old = editingItem.value;
    if (old == null) return;

    final updated = old.copyWith(
      sale: num.tryParse(editSaleCtrl.text) ?? old.sale,
      pSale: num.tryParse(editPSaleCtrl.text) ?? old.pSale,
      offer: num.tryParse(editOfferCtrl.text) ?? old.offer,
      quantity: int.tryParse(editQtyCtrl.text) ?? old.quantity,
    );

    // update current page list
    final index = items.indexWhere((e) => e.id == old.id);
    if (index != -1) {
      items[index] = updated;
      items.refresh(); // 🔑 force UI update
    }

    Get.back(); // close dialog
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    editSaleCtrl.dispose();
    editPSaleCtrl.dispose();
    editOfferCtrl.dispose();
    editQtyCtrl.dispose();
    super.onClose();
  }
}

/// ===================== BASE PRODUCTS =====================
const List<DrugItemModel> _baseProducts = [
  DrugItemModel(
    id: 'base_1',
    name: 'Sergel 20mg',
    type: 'Capsule',
    pack: '10 capsule in a strip',
    sale: 5,
    pSale: 7,
    offer: 4,
    quantity: 0,
  ),
  DrugItemModel(
    id: 'base_2',
    name: 'Sergel 40mg',
    type: 'Capsule',
    pack: '10 capsule in a strip',
    sale: 10,
    pSale: 12,
    offer: 9,
    quantity: 15,
  ),
  DrugItemModel(
    id: 'base_3',
    name: 'Napa 500mg',
    type: 'Tablet',
    pack: '10 tablet in a strip',
    sale: 2,
    pSale: 3,
    offer: 1.5,
    quantity: 0,
  ),
  DrugItemModel(
    id: 'base_4',
    name: 'Ace Plus',
    type: 'Tablet',
    pack: '10 tablet in a strip',
    sale: 3,
    pSale: 4,
    offer: 2.5,
    quantity: 20,
  ),
  DrugItemModel(
    id: 'base_5',
    name: 'Fexo 120mg',
    type: 'Tablet',
    pack: '10 tablet in a strip',
    sale: 12,
    pSale: 14,
    offer: 11,
    quantity: 5,
  ),
];
