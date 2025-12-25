import 'package:drug/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/models/drug_item_model.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import 'all_list_controller.dart';

class AllListView extends GetView<AllListController> {
  AllListView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'MEDI-STOCK',
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All-List',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.primary,
                      ),
                    ),
                    10.verticalSpace,

                    // Top filters row (UI only - optional)
                    _TopFiltersRow(),

                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        border: Border.all(color: AppPalette.border),
                      ),
                      child: _SearchBar(),
                    ),

                    _TableHeader(),

                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const _LoadingState();
                        }

                        final items = controller.items;

                        if (controller.totalItems == 0) {
                          return _EmptyState(
                            onReload: () => controller.fetchPage(page: 1),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.only(top: 0.h, bottom: 12.h),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _RowCard(
                              item: item,
                              index: index,
                              onEdit: () => controller.onEditItem(item),
                            );
                          },
                        );
                      }),
                    ),

                    8.verticalSpace,

                    Obx(() {
                      return _PaginationBar(
                        showingFrom: controller.showingFrom,
                        showingTo: controller.showingTo,
                        total: controller.totalItems,
                        currentPage: controller.currentPage.value,
                        totalPages: controller.totalPages,
                        onPrev: controller.prevPage,
                        onNext: controller.nextPage,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopFiltersRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppPalette.primary,
        border: Border.all(color: const Color(0xFF0930A8)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Expanded(child: _FakeDropdown(title: 'M-Bill-Mode')),
          Expanded(child: _FakeDropdown(title: 'Sale')),
          Spacer(),
        ],
      ),
    );
  }
}

class _FakeDropdown extends StatelessWidget {
  final String title;
  const _FakeDropdown({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        border: Border.all(color: const Color(0xFFB8B8B8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, size: 20.sp, color: Colors.grey[700]),
        ],
      ),
    );
  }
}

class _SearchBar extends GetView<AllListController> {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D0D0)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          12.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller.searchCtrl,
              textAlignVertical: TextAlignVertical.center,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'search stock product',
                border: InputBorder.none,
                isCollapsed: true,
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
          Obx(() {
            final hasText = controller.searchQuery.value.trim().isNotEmpty;
            return InkWell(
              onTap: hasText ? controller.clearSearch : null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Icon(
                  hasText ? Icons.close : Icons.search,
                  size: 22.sp,
                  color: const Color(0xFF0D2EBE),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  static const _headerBlack = Color(0xFF0B0F15);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      color: _headerBlack,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Expanded(
            flex: 42,
            child: Text(
              'Product Description',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 18,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rate',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 30,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Status',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Action',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final DrugItemModel item;
  final int index;
  final VoidCallback onEdit;

  const _RowCard({
    required this.item,
    required this.index,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bg = index.isEven ? const Color(0xFFE7E7E7) : const Color(0xFFF3F3F3);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      color: bg,
      child: Row(
        children: [
          /// Product description
          Expanded(
            flex: 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                6.verticalSpace,
                Row(
                  children: [
                    _Tag(item.type),
                    6.horizontalSpace,
                    _Tag(item.pack),
                  ],
                ),
              ],
            ),
          ),

          /// Rate
          Expanded(
            flex: 20,
            child: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: _RateText(
                sale: item.sale,
                pSale: item.pSale,
                offer: item.offer,
              ),
            ),
          ),

          /// Status
          Expanded(
            flex: 32,
            child: Align(
              alignment: Alignment.center,
              child: _StockPill(inStock: item.inStock),
            ),
          ),

          /// Action
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 30.h,
                child: FittedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B64B7),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onEdit,
                    child: Text(
                      'EDIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RateText extends StatelessWidget {
  final num sale;
  final num pSale;
  final num offer;

  const _RateText({
    required this.sale,
    required this.pSale,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sale : \$ $sale, P-sale:\$$pSale,',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w300,
          ),
        ),
        4.verticalSpace,
        Text(
          'Offer : \$ $offer',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppPalette.chipFill,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 140.w),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _StockPill extends StatelessWidget {
  final bool inStock;
  const _StockPill({required this.inStock});

  @override
  Widget build(BuildContext context) {
    final bg = inStock ? const Color(0xFFD5EED0) : const Color(0xFFF6D0D6);
    final fg = inStock ? const Color(0xFF1B7B2C) : const Color(0xFFD61B2A);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: FittedBox(
        child: Text(
          inStock ? 'STK-IN' : 'STK OUT',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final int showingFrom;
  final int showingTo;
  final int total;
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _PaginationBar({
    required this.showingFrom,
    required this.showingTo,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      color: const Color(0xFFE5E5E5),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing $showingFrom-$showingTo of $total',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),

          Row(
            children: [
              _CircleBtn(
                icon: Icons.arrow_back,
                onTap: currentPage <= 1 ? null : onPrev,
              ),
              12.horizontalSpace,
              Text(
                '$currentPage of $totalPages',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
              ),
              12.horizontalSpace,
              _CircleBtn(
                icon: Icons.arrow_forward,
                onTap: currentPage >= totalPages ? null : onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFBDBDBD) : const Color(0xFF6E6E6E),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.sp, color: Colors.white),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 28.w,
        height: 28.w,
        child: const CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onReload;
  const _EmptyState({required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No items found',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            10.verticalSpace,
            SizedBox(
              height: 38.h,
              child: ElevatedButton(
                onPressed: onReload,
                child: const Text('Reload'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
