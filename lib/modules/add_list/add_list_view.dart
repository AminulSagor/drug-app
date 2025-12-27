// lib/modules/add_list/add_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/suggestion_box.dart';
import 'add_list_controller.dart';

class AddListView extends GetView<AddListController> {
  AddListView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final LayerLink searchLink = LayerLink();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'MEDI-STOCK',
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(
              child: Stack(
                children: [
                  /// ================= MAIN CONTENT =================
                  SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add List',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D2EBE),
                          ),
                        ),
                        6.verticalSpace,

                        /// SEARCH BAR ANCHOR
                        CompositedTransformTarget(
                          link: searchLink,
                          child: const _SearchBar(),
                        ),

                        8.verticalSpace,

                        /// SELECTED PRODUCT
                        Obx(() {
                          final product = controller.selectedProduct.value;

                          if (product == null) {
                            return Container(
                              width: double.infinity,
                              height: 44.h,
                              alignment: Alignment.center,
                              color: const Color(0xFF0D2EBE),
                              child: Text(
                                'No selected product',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }

                          return Container(
                            padding: EdgeInsets.all(12.w),
                            color: const Color(0xFF0D2EBE),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// ✅ product name + strength (small)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          product.productName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        4.horizontalSpace,
                                        Text(
                                          product.strength,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(.9),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    6.verticalSpace,
                                    Row(
                                      children: [
                                        _Tag(product.type),
                                        6.horizontalSpace,
                                        _Tag(product.unitInPack),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '৳ ${product.retailMaxPrice}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        12.verticalSpace,

                        /// FORM
                        const _AddToListForm(),

                        120.verticalSpace,
                      ],
                    ),
                  ),

                  /// ================= SEARCH DROPDOWN =================
                  Obx(() {
                    if (!controller.isSearching.value) return const SizedBox();

                    return CompositedTransformFollower(
                      link: searchLink,
                      showWhenUnlinked: false,
                      offset: Offset(0, 44.h),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32.w,
                        child: const SuggestionBox(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(text, style: TextStyle(fontSize: 10.sp)),
    );
  }
}

class _SearchBar extends GetView<AddListController> {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D0D0)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: const BoxDecoration(color: Color(0xFF0D2EBE)),
            child: Center(
              child: Image.asset(
                'assets/search_icon.png',
                width: 18.w,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.searchCtrl,
              textAlignVertical: TextAlignVertical.center,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'search product...',
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToListForm extends GetView<AddListController> {
  const _AddToListForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InputRow(
          label: 'Sale',
          hint: 'Enter normal price',
          controller: controller.saleCtrl,
          inputType: _InputType.decimal,
        ),
        _InputRow(
          label: 'P-Sale',
          hint: 'Enter peak-hour price',
          controller: controller.pSaleCtrl,
          inputType: _InputType.decimal,
        ),
        _InputRow(
          label: 'M-Offer',
          hint: 'Enter mediboy offer price',
          controller: controller.offerCtrl,
          inputType: _InputType.decimal,
        ),
        _InputRow(
          label: 'Max-Acpt. QTY',
          hint: 'Max order quantity',
          controller: controller.maxQtyCtrl,
          inputType: _InputType.integer,
        ),
        4.verticalSpace,
        Obx(() {
          return SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2EBE),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: controller.isSubmitting.value
                  ? null
                  : controller.submitAddStock,
              child: controller.isSubmitting.value
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Add To List',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          );
        }),
      ],
    );
  }
}

enum _InputType { decimal, integer }

class _InputRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final _InputType inputType;

  const _InputRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.inputType,
  });

  bool get _isLongLabel => label.length > 10;

  @override
  Widget build(BuildContext context) {
    final isInteger = inputType == _InputType.integer;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: _isLongLabel ? 120.w : 90.w,
            height: 44.h,
            alignment: Alignment.center,
            color: const Color(0xFF0D2EBE),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D0D0)),
              ),
              child: TextField(
                controller: controller,
                keyboardType: isInteger
                    ? TextInputType.number
                    : const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  isInteger
                      ? FilteringTextInputFormatter.digitsOnly
                      : FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}$'),
                        ),
                ],
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 8.h, bottom: 6.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
