import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../modules/add_list/add_list_controller.dart';

class SuggestionBox extends GetView<AddListController> {
  const SuggestionBox({super.key});

  static const int _maxVisibleItems = 5;
  static const double _itemHeight = 56;

  double _calculateHeight(int count) {
    final visibleItems = count > _maxVisibleItems ? _maxVisibleItems : count;

    return (visibleItems * _itemHeight).h;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Obx(() {
      final itemCount = controller.filteredProducts.length;

      return Container(
        height: itemCount == 0 ? 56.h : _calculateHeight(itemCount),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: itemCount == 0
            ? _NoResult()
            : Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thickness: 4,
                radius: const Radius.circular(4),
                interactive: true,
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: itemCount,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];

                    return InkWell(
                      onTap: () => controller.selectProduct(product),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    product.company ??
                                        'Healthcare Pharmaceuticals Ltd.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '৳${product.price}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      );
    });
  }
}

class _NoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No product found',
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
