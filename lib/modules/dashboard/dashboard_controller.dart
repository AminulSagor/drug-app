import 'dart:async';
import 'package:get/get.dart';
import '../../core/models/drug_item_model.dart';
import '../../core/models/order_item_model.dart';
import '../../core/models/order_model.dart';

class DashboardController extends GetxController {
  /// page-level loading (only once)
  final isPageLoading = true.obs;

  /// order-level loading (next / prev)
  final isOrderLoading = false.obs;

  /// mock backend storage
  final List<OrderModel> _allOrders = [];

  /// currently visible order
  final orders = <OrderModel>[].obs;

  final currentIndex = 0.obs;

  int get totalOrders => _allOrders.length;

  /// ===================== STATS =====================
  int get pendingCount =>
      _allOrders.where((e) => e.status == OrderStatus.pending).length;

  int get progressiveCount =>
      _allOrders.where((e) => e.status == OrderStatus.inProgress).length;

  int get listedItemsCount => _allOrders.length;

  num get totalCommission =>
      _allOrders.fold<num>(0, (sum, e) => sum + e.commission);

  /// ===================== INIT =====================
  @override
  void onInit() {
    super.onInit();
    _seedMockOrders();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    isPageLoading.value = true;
    await fetchOrderAt(index: 0, showLoader: false);
    isPageLoading.value = false;
  }

  void refreshPage() async {
    await _initialLoad();
  }

  /// ===================== MOCK DATA =====================
  void _seedMockOrders() {
    final drugs = [
      // DrugItemModel(
      //   id: 'd1',
      //   name: 'Sergel 20mg',
      //   type: 'Capsule',
      //   pack: '10 capsule in a strip',
      //   sale: 6.5,
      //   pSale: 7,
      //   offer: 6,
      //   quantity: 50,
      // ),
      // DrugItemModel(
      //   id: 'd2',
      //   name: 'Napa 500mg',
      //   type: 'Tablet',
      //   pack: '10 tablet in a strip',
      //   sale: 2,
      //   pSale: 3,
      //   offer: 1.8,
      //   quantity: 100,
      // ),
    ];

    // _allOrders.addAll(
    //   List.generate(5, (i) {
    //     return OrderModel(
    //       orderNumber: '#12354${6 + i}',
    //       customerName: 'Customer ${i + 1}',
    //       customerPhone: '01700${i}XXXX',
    //       deliveryType: i.isEven
    //           ? DeliveryType.homeDelivery
    //           : DeliveryType.selfPickup,
    //       commission: 100 + (i * 100),
    //       status: OrderStatus.pending,
    //       items: List.generate(
    //         2 + (i % 3),
    //         (x) => OrderItemModel(
    //           drug: drugs[x % drugs.length],
    //           quantity: 5 + x,
    //           rate: drugs[x % drugs.length].sale,
    //         ),
    //       ),
    //     );
    //   }),
    // );
  }

  /// ===================== FETCH =====================
  Future<void> fetchOrderAt({
    required int index,
    bool showLoader = true,
  }) async {
    if (index < 0 || index >= _allOrders.length) return;

    if (showLoader) isOrderLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 600));

    orders.assignAll([_allOrders[index]]);
    currentIndex.value = index;

    if (showLoader) isOrderLoading.value = false;
  }

  /// ===================== NAV =====================
  void nextOrder() {
    if (currentIndex.value < _allOrders.length - 1) {
      fetchOrderAt(index: currentIndex.value + 1);
    }
  }

  void prevOrder() {
    if (currentIndex.value > 0) {
      fetchOrderAt(index: currentIndex.value - 1);
    }
  }

  /// ===================== ACTION =====================
  void acceptOrder(OrderModel order) {
    _updateStatus(order, OrderStatus.accepted);
  }

  void declineOrder(OrderModel order) {
    _updateStatus(order, OrderStatus.cancelled);
  }

  void _updateStatus(OrderModel order, OrderStatus status) {
    final idx = _allOrders.indexWhere(
      (e) => e.orderNumber == order.orderNumber,
    );
    if (idx == -1) return;

    _allOrders[idx] = OrderModel(
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      items: order.items,
      status: status,
      deliveryType: order.deliveryType,
      commission: order.commission,
    );

    orders[0] = _allOrders[idx];
    orders.refresh();
  }
}
