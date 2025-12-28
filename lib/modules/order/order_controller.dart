import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_exception.dart';
import 'models/order_with_details_response_model.dart';
import 'services/order_api.dart';

class OrderController extends GetxController {
  OrderController({OrderApi? api}) : _api = api ?? OrderApi();
  final OrderApi _api;

  /// UI
  final searchCtrl = TextEditingController();
  final searchQuery = ''.obs;

  /// loading for list area
  final isLoading = false.obs;

  /// ✅ loading for "Peaked" action (per-order)
  final clearingOrderIds = <int>{}.obs;

  /// stats from API
  final progressCount = 0.obs;
  final cancelledCount = 0.obs;
  final deliveredCount = 0.obs;

  /// list
  final orders = <OrderWithDetailsModel>[].obs;

  /// pagination (from list API)
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalItems = 0.obs;
  final pageSize = 1.obs; // API per_page

  /// keep last list meta to restore after search clears
  int _lastListPage = 1;
  int _lastListTotalPages = 1;
  int _lastListTotalItems = 0;
  int _lastListPerPage = 1;
  List<OrderWithDetailsModel> _lastListData = [];

  Timer? _pollTimer;
  Timer? _searchDebounce;

  int _searchReqId = 0; // to ignore stale responses

  bool get isSearching => searchQuery.value.trim().isNotEmpty;

  int get showingFrom {
    if (orders.isEmpty) return 0;
    if (isSearching) return 1;
    return ((currentPage.value - 1) * pageSize.value) + 1;
  }

  int get showingTo {
    if (orders.isEmpty) return 0;
    if (isSearching) return orders.length;

    final to = currentPage.value * pageSize.value;
    return to > totalItems.value ? totalItems.value : to;
  }

  @override
  void onInit() {
    super.onInit();
    _initialLoadAndStartPolling();
  }

  Future<void> _initialLoadAndStartPolling() async {
    await fetchPage(page: 1, showLoader: true);

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      if (!isSearching) {
        await fetchPage(page: currentPage.value, showLoader: false);
      }
    });
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    _searchDebounce?.cancel();
    searchCtrl.dispose();
    super.onClose();
  }

  Future<void> refreshPage() async {
    if (isSearching) {
      await _performSearch(searchQuery.value, showLoader: true);
      return;
    }
    await fetchPage(page: currentPage.value, showLoader: true);
  }

  Future<void> fetchPage({required int page, required bool showLoader}) async {
    if (showLoader) isLoading.value = true;

    try {
      final res = await _api.getOrdersWithDetails(page: page);

      progressCount.value = res.progress;
      cancelledCount.value = res.cancelled;
      deliveredCount.value = res.delivered;

      currentPage.value = res.orders.currentPage;
      totalPages.value = res.orders.lastPage;
      totalItems.value = res.orders.total;
      pageSize.value = res.orders.perPage == 0 ? 1 : res.orders.perPage;

      orders.assignAll(res.orders.data);

      _lastListPage = currentPage.value;
      _lastListTotalPages = totalPages.value;
      _lastListTotalItems = totalItems.value;
      _lastListPerPage = pageSize.value;
      _lastListData = List<OrderWithDetailsModel>.from(res.orders.data);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  void nextPage() {
    if (isSearching) return;
    if (currentPage.value >= totalPages.value) return;
    fetchPage(page: currentPage.value + 1, showLoader: true);
  }

  void prevPage() {
    if (isSearching) return;
    if (currentPage.value <= 1) return;
    fetchPage(page: currentPage.value - 1, showLoader: true);
  }

  void onSearchChanged(String v) {
    final q = v.trim();
    searchQuery.value = q;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
      if (q.isEmpty) {
        _restoreLastListState();
        return;
      }
      await _performSearch(q, showLoader: true);
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    searchCtrl.clear();
    searchQuery.value = '';
    _restoreLastListState();
  }

  void _restoreLastListState() {
    currentPage.value = _lastListPage;
    totalPages.value = _lastListTotalPages;
    totalItems.value = _lastListTotalItems;
    pageSize.value = _lastListPerPage;
    orders.assignAll(_lastListData);
  }

  Future<void> _performSearch(String q, {required bool showLoader}) async {
    final parsed = int.tryParse(q);
    if (parsed == null) {
      orders.clear();
      totalItems.value = 0;
      totalPages.value = 1;
      currentPage.value = 1;
      pageSize.value = 1;
      return;
    }

    final reqId = ++_searchReqId;

    if (showLoader) isLoading.value = true;
    try {
      final result = await _api.searchOrdersByOrderNumber(orderNumber: parsed);

      if (reqId != _searchReqId) return;

      orders.assignAll(result);

      currentPage.value = 1;
      totalPages.value = 1;
      totalItems.value = result.length;
      pageSize.value = result.isEmpty ? 1 : result.length;
    } on ApiException catch (e) {
      if (reqId != _searchReqId) return;
      Get.snackbar('Error', e.message);
    } catch (_) {
      if (reqId != _searchReqId) return;
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  /// ✅ NEW: Clear Order (called from "Peaked" button)
  Future<void> clearOrder({required int orderId}) async {
    if (orderId <= 0) return;
    if (clearingOrderIds.contains(orderId)) return;

    clearingOrderIds.add(orderId);
    try {
      final msg = await _api.clearOrder(orderId: orderId);
      Get.snackbar('Success', msg);

      // ✅ Refresh list without full loader
      if (isSearching) {
        await _performSearch(searchQuery.value, showLoader: false);
      } else {
        await fetchPage(page: currentPage.value, showLoader: false);
      }

      // optional: close details dialog after success
      // if (Get.isDialogOpen == true) Get.back();
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      clearingOrderIds.remove(orderId);
    }
  }
}
