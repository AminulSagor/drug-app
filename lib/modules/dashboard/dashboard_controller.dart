import 'dart:async';
import 'package:get/get.dart';

import '../../core/network/api_exception.dart';
import 'models/dashboard_response_model.dart';
import 'services/dashboard_api.dart';

class DashboardController extends GetxController {
  DashboardController({DashboardApi? api}) : _api = api ?? DashboardApi();
  final DashboardApi _api;

  final isPageLoading = true.obs;
  final isOrderLoading = false.obs;

  final orders = <PendingOrderModel>[].obs;
  final List<PendingOrderModel> _pendingOrders = [];

  final currentIndex = 0.obs;
  Timer? _pollTimer;

  final listedItemsCount = 0.obs;
  final progressiveCount = 0.obs;
  final pendingCount = 0.obs;
  final totalCommission = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initialLoadAndStartPolling();
  }

  Future<void> _initialLoadAndStartPolling() async {
    isPageLoading.value = true;
    await _fetchDashboard(showLoader: false);
    isPageLoading.value = false;

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _fetchDashboard(showLoader: false);
    });
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  Future<void> refreshPage() async {
    await _fetchDashboard(showLoader: true);
  }

  Future<void> _fetchDashboard({required bool showLoader}) async {
    if (showLoader) isOrderLoading.value = true;

    try {
      final DashboardResponseModel res = await _api.getDashboardData();

      listedItemsCount.value = res.totalItem;
      progressiveCount.value = res.progressiveOrders;
      pendingCount.value = res.pendingOrders.length;
      totalCommission.value = res.account.toDouble();

      _pendingOrders
        ..clear()
        ..addAll(res.pendingOrders);

      if (_pendingOrders.isEmpty) {
        orders.clear();
        currentIndex.value = 0;
      } else {
        final idx = currentIndex.value.clamp(0, _pendingOrders.length - 1);
        currentIndex.value = idx;
        orders.assignAll([_pendingOrders[idx]]);
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      if (showLoader) isOrderLoading.value = false;
    }
  }

  void nextOrder() {
    if (isOrderLoading.value) return;
    if (_pendingOrders.isEmpty) return;

    if (currentIndex.value < _pendingOrders.length - 1) {
      currentIndex.value++;
      orders.assignAll([_pendingOrders[currentIndex.value]]);
    }
  }

  void prevOrder() {
    if (isOrderLoading.value) return;
    if (_pendingOrders.isEmpty) return;

    if (currentIndex.value > 0) {
      currentIndex.value--;
      orders.assignAll([_pendingOrders[currentIndex.value]]);
    }
  }

  /// ===================== ACCEPT / DECLINE =====================

  Future<void> acceptOrder(PendingOrderModel order) async {
    await _acceptDecline(order: order, actionValue: 1);
  }

  Future<void> declineOrder(PendingOrderModel order) async {
    await _acceptDecline(order: order, actionValue: 0);
  }

  Future<void> _acceptDecline({
    required PendingOrderModel order,
    required int actionValue,
  }) async {
    if (isOrderLoading.value) return;

    isOrderLoading.value = true;
    try {
      await _api.acceptDeclineOrder(
        orderId: order.id, // ✅ use order id
        actionValue: actionValue,
      );

      // ✅ refresh dashboard so stats + pending orders update from server
      await _fetchDashboard(showLoader: false);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isOrderLoading.value = false;
    }
  }
}
