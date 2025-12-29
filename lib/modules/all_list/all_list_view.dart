import 'package:drug/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'all_list_controller.dart';
import 'models/listed_item_model.dart';

class AllListView extends GetView<AllListController> {
  const AllListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
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

                  const _TopFiltersRow(),

                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppPalette.primary,
                      border: Border.all(color: AppPalette.border),
                    ),
                    child: const _SearchBar(),
                  ),

                  _TableHeader(),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const _LoadingState();
                      }

                      final items = controller.items;

                      if (items.isEmpty) {
                        return _EmptyState(
                          title: controller.isSearching
                              ? 'No match found'
                              : 'No items to show',
                          subtitle: controller.isSearching
                              ? 'Try a different keyword.'
                              : 'Tap reload to fetch latest stock.',
                          buttonText: controller.isSearching
                              ? 'Clear Search'
                              : 'Reload',
                          onReload: controller.isSearching
                              ? controller.clearSearch
                              : () => controller.fetchPage(page: 1),
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
                    // hide pagination while searching
                    if (controller.isSearching) return const SizedBox.shrink();

                    return _PaginationBar(
                      showingFrom: controller.showingFrom,
                      showingTo: controller.showingTo,
                      total: controller.totalItems.value,
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
    );
  }
}

class _TopFiltersRow extends GetView<AllListController> {
  const _TopFiltersRow();

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
          Expanded(child: _PlainBox(title: 'M-Bill-Mode')),
          Expanded(
            child: Obx(() {
              final selected = controller.selectedSaleMode.value;
              final busy = controller.isBillModeLoading.value;

              return _SaleDropdown(
                value: selected,
                isLoading: busy,
                onChanged: busy
                    ? null
                    : (v) {
                        if (v == null) return;
                        controller.changeBillMode(v);
                      },
              );
            }),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _PlainBox extends StatelessWidget {
  final String title;
  const _PlainBox({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        border: Border.all(color: const Color(0xFFB8B8B8)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SaleDropdown extends StatelessWidget {
  final SaleModeOption value;
  final ValueChanged<SaleModeOption?>? onChanged;
  final bool isLoading;

  const _SaleDropdown({
    required this.value,
    required this.onChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        border: Border.all(color: const Color(0xFFB8B8B8)),
      ),
      child: isLoading
          ? Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Updating...',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<SaleModeOption>(
                isExpanded: true,
                value: value,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: Colors.grey[700],
                ),
                items: const [
                  DropdownMenuItem(
                    value: SaleModeOption.sale,
                    child: Text('Sale'),
                  ),
                  DropdownMenuItem(
                    value: SaleModeOption.pSale,
                    child: Text('P-Sale'),
                  ),
                ],
                onChanged: onChanged, // null => disabled
              ),
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
          _HeaderCell(
            'Product Description',
            flex: 42,
            align: Alignment.centerLeft,
          ),
          _HeaderCell('Rate', flex: 18, align: Alignment.centerLeft),
          _HeaderCell('Status', flex: 30, align: Alignment.center),
          _HeaderCell('Action', flex: 14, align: Alignment.centerRight),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final Alignment align;

  const _HeaderCell(this.text, {required this.flex, required this.align});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: align,
        child: Text(
          text,
          // ✅ allow wrap
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final ListedItemModel item;
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
      color: bg,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ top align
        children: [
          /// Product Description
          Expanded(
            flex: 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ wrap-able product name
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: item.productName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.15,
                        ),
                      ),
                      TextSpan(
                        text: item.quantity.isEmpty ? '' : ' ${item.quantity}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                  maxLines: 3, // ✅ allow wrap
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,

                // ✅ Wrap chips instead of Row to avoid overlap
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [_Tag(item.type), _Tag(item.unitInPack)],
                ),
              ],
            ),
          ),

          8.horizontalSpace,

          /// Rate
          Expanded(
            flex: 18,
            child: _RateText(
              sale: item.sale,
              pSale: item.pSale,
              offer: item.offer,
            ),
          ),

          8.horizontalSpace,

          /// Status
          Expanded(
            flex: 30,
            child: Align(
              alignment: Alignment.topCenter, // ✅ top center
              child: _StockPill(inStock: item.inStock),
            ),
          ),

          8.horizontalSpace,

          /// Action
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.topRight, // ✅ top right
              child: SizedBox(
                height: 32.h,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B64B7),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          'Sale : \$ $sale,\nP-sale : \$ $pSale,',
          softWrap: true,
          maxLines: 3, // ✅ wrap
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        4.verticalSpace,
        Text(
          'Offer : \$ $offer',
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            height: 1.2,
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
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppPalette.chipFill,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Text(
        text,
        softWrap: false,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.black,
          fontWeight: FontWeight.w500,
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        inStock ? 'STK-IN' : 'STK OUT',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          color: fg,
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
  final String title;
  final String subtitle;
  final String buttonText;

  const _EmptyState({
    required this.onReload,
    this.title = 'No items found',
    this.subtitle = 'Try reloading.',
    this.buttonText = 'Reload',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
            ),
            6.verticalSpace,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            ),
            12.verticalSpace,
            SizedBox(
              height: 38.h,
              child: ElevatedButton(
                onPressed: onReload,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
