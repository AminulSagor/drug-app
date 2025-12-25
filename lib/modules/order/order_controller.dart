import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/drug_item_model.dart';
import '../../core/models/order_item_model.dart';
import '../../core/models/order_model.dart';

class OrderController extends GetxController {
  /// UI
  final searchCtrl = TextEditingController();
  final searchQuery = ''.obs;

  /// Loading (list area)
  final isLoading = false.obs;

  /// Current page data only (what list shows)
  final orders = <OrderModel>[].obs;

  /// Pagination (mock backend)
  final int pageSize = 20;
  final int totalItems = 600;
  final currentPage = 1.obs;

  int get totalPages => (totalItems / pageSize).ceil();

  int get showingFrom {
    if (orders.isEmpty) return 0;
    return ((currentPage.value - 1) * pageSize) + 1;
  }

  int get showingTo {
    if (orders.isEmpty) return 0;
    final to = currentPage.value * pageSize;
    return to > totalItems ? totalItems : to;
  }

  /// ===================== FIXED STATS (GLOBAL) =====================
  /// These values never change with pagination.
  /// We compute them deterministically across all 600 mock orders.
  late final int _globalProgressCount;
  late final int _globalCancelledCount;
  late final int _globalDeliveredCount;

  int get progressCount => _globalProgressCount;
  int get cancelledCount => _globalCancelledCount;
  int get deliveredCount => _globalDeliveredCount;

  /// ===================== INIT =====================
  @override
  void onInit() {
    super.onInit();

    // pre-calc fixed stats for all 600
    final stats = _computeGlobalStats(totalItems);
    _globalProgressCount = stats.$1;
    _globalCancelledCount = stats.$2;
    _globalDeliveredCount = stats.$3;

    fetchPage(page: 1);
  }

  void refreshPage() {
    // if searching -> refresh search, else refresh current page
    if (_isSearching) {
      searchByOrderNumber(searchQuery.value);
    } else {
      fetchPage(page: currentPage.value);
    }
  }

  bool get _isSearching => searchQuery.value.trim().isNotEmpty;

  /// ===================== MOCK: PAGE FETCH =====================
  Future<void> fetchPage({required int page}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 650));

    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize) > totalItems
        ? totalItems
        : (startIndex + pageSize);

    final pageData = <OrderModel>[];

    for (int i = startIndex; i < endIndex; i++) {
      pageData.add(_buildOrderAt(i));
    }

    orders.assignAll(pageData);
    currentPage.value = page;
    isLoading.value = false;
  }

  /// ===================== SEARCH (FUNCTIONAL) =====================
  /// Mock "server search": match substring from the numeric part of orderNumber.
  Future<void> searchByOrderNumber(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      // back to normal paging
      currentPage.value = 1;
      await fetchPage(page: 1);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 450));

    // scan all 600 and pick matches (limit to first pageSize results for UI)
    final results = <OrderModel>[];
    for (int i = 0; i < totalItems; i++) {
      final orderNo = (563500 + i).toString(); // numeric part
      if (orderNo.contains(q)) {
        results.add(_buildOrderAt(i));
        if (results.length >= pageSize) break;
      }
    }

    // show search results, reset page indicator to 1
    orders.assignAll(results);
    currentPage.value = 1;

    isLoading.value = false;
  }

  void onSearchChanged(String v) {
    searchQuery.value = v.trim();
    // live search like your UI
    searchByOrderNumber(searchQuery.value);
  }

  void clearSearch() {
    searchCtrl.clear();
    searchQuery.value = '';
    fetchPage(page: 1);
  }

  /// ===================== PAGINATION =====================
  void nextPage() {
    // disable paging while searching (because showing search results)
    if (_isSearching) return;

    if (currentPage.value < totalPages) {
      fetchPage(page: currentPage.value + 1);
    }
  }

  void prevPage() {
    if (_isSearching) return;

    if (currentPage.value > 1) {
      fetchPage(page: currentPage.value - 1);
    }
  }

  /// ===================== CLEANUP =====================
  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }

  /// ===================== ORDER BUILDER =====================
  OrderModel _buildOrderAt(int i) {
    return OrderModel(
      orderNumber: '#${563500 + i}',
      customerName: _names[i % _names.length],
      customerPhone: _phones[i % _phones.length],
      deliveryType: i.isEven
          ? DeliveryType.homeDelivery
          : DeliveryType.selfPickup,
      commission: (50 + (i % 7) * 10),
      status: _statusCycle[i % _statusCycle.length],
      items: _mockItems(seed: i),
    );
  }

  List<OrderItemModel> _mockItems({required int seed}) {
    final count = 3 + (seed % 3); // 3..5 items
    return List.generate(count, (idx) {
      final d = _baseDrugs[(seed + idx) % _baseDrugs.length];
      final qty = 5 + ((seed + idx) % 6); // 5..10
      return OrderItemModel(drug: d, quantity: qty, rate: d.sale);
    });
  }

  /// ===================== FIXED STATS CALC =====================
  /// Returns: (progress, cancelled, delivered)
  (int, int, int) _computeGlobalStats(int total) {
    int progress = 0;
    int cancelled = 0;
    int delivered = 0;

    for (int i = 0; i < total; i++) {
      final s = _statusCycle[i % _statusCycle.length];
      if (s == OrderStatus.inProgress) progress++;
      if (s == OrderStatus.cancelled) cancelled++;
      if (s == OrderStatus.completed) delivered++;
    }

    return (progress, cancelled, delivered);
  }
}

/// ---------------- MOCK CONSTANTS ----------------

final _statusCycle = <OrderStatus>[
  OrderStatus.accepted,
  OrderStatus.cancelled,
  OrderStatus.inProgress,
  OrderStatus.accepted,
  OrderStatus.pending,
  OrderStatus.completed,
];

final _names = <String>[
  'Fazle Rabbi',
  'Sabbir Hasan',
  'Nusrat Jahan',
  'Rafi Ahmed',
  'Mim Akter',
];

final _phones = <String>[
  '01616815056',
  '01711002233',
  '01855443322',
  '01977889900',
  '01300998877',
];

final _baseDrugs = <DrugItemModel>[
  DrugItemModel(
    id: 'd1',
    name: 'Sergel 20mg',
    type: 'Capsule',
    pack: '10 capsule in a strip',
    sale: 6.5,
    pSale: 7,
    offer: 6,
    quantity: 100,
  ),
  DrugItemModel(
    id: 'd2',
    name: 'Zymet Pro 325mg',
    type: 'Capsule',
    pack: '10 capsule in a strip',
    sale: 9.5,
    pSale: 10,
    offer: 9,
    quantity: 40,
  ),
  DrugItemModel(
    id: 'd3',
    name: 'Napa 500mg',
    type: 'Tablet',
    pack: '10 tablet in a strip',
    sale: 2.0,
    pSale: 2.5,
    offer: 1.8,
    quantity: 200,
  ),
  DrugItemModel(
    id: 'd4',
    name: 'Ace Plus',
    type: 'Tablet',
    pack: '10 tablet in a strip',
    sale: 3.0,
    pSale: 3.5,
    offer: 2.6,
    quantity: 120,
  ),
  DrugItemModel(
    id: 'd5',
    name: 'Fexo 120mg',
    type: 'Tablet',
    pack: '10 tablet in a strip',
    sale: 12,
    pSale: 13,
    offer: 11,
    quantity: 60,
  ),
];
