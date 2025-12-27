import 'package:drug/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_button.dart';
import '../all_list_controller.dart';

class EditDrugDialog extends GetView<AllListController> {
  const EditDrugDialog({super.key});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        final item = controller.editingItem.value;
        if (item == null) return const SizedBox();

        return Container(
          color: AppPalette.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// HEADER
                Container(
                  color: _primary,
                  padding: EdgeInsets.all(14.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                5.w.horizontalSpace,
                                Text(
                                  item.quantity,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            10.h.verticalSpace,

                            /// ✅ both tags
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                _Tag(item.type),
                                _Tag(item.unitInPack),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '৳ ${item.currentStock?.salePrice.toString() ?? '0'} ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                /// FIELDS (✅ numeric-only)
                _EditField(
                  label: 'Sale',
                  controller: controller.editSaleCtrl,
                  allowDecimal: true,
                ),
                _EditField(
                  label: 'P-Sale',
                  controller: controller.editPSaleCtrl,
                  allowDecimal: true,
                ),
                _EditField(
                  label: 'M-Offer',
                  controller: controller.editOfferCtrl,
                  allowDecimal: true,
                ),
                _EditField(
                  label: 'Max-Acpt. QTY',
                  controller: controller.editQtyCtrl,
                  allowDecimal: false, // ✅ integer only
                ),

                12.verticalSpace,

                /// ACTIONS
                Obx(() {
                  final busy = controller.isEditLoading.value;
                  final action = controller.editAction.value;

                  final isStockLoading = busy && action == EditAction.stockOut;
                  final isUpdateLoading = busy && action == EditAction.update;

                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12.w, 10.h, 6.w, 10.h),
                          child: CustomButton(
                            btnColor: const Color(0xFFD0021B),
                            btnText: 'STOCK-OUT',
                            isLoading: isStockLoading,
                            onTap: busy
                                ? null
                                : controller.onPressStockOut, // ✅ disable both
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(6.w, 10.h, 12.w, 10.h),
                          child: CustomButton(
                            btnColor: const Color(0xFF10A845),
                            btnText: 'UPDATE',
                            isLoading: isUpdateLoading,
                            onTap: busy
                                ? null
                                : controller.onPressUpdate, // ✅ disable both
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool allowDecimal;

  const _EditField({
    required this.label,
    required this.controller,
    required this.allowDecimal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 110.w,
            height: 40.h,
            alignment: Alignment.center,
            color: const Color(0xFF0D2EBE),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D0D0)),
              ),
              child: TextField(
                controller: controller,
                keyboardType: allowDecimal
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
                inputFormatters: allowDecimal
                    ? <TextInputFormatter>[_SingleDecimalFormatter()]
                    : <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ allows digits + a single dot (no letters, no multiple dots)
class _SingleDecimalFormatter extends TextInputFormatter {
  static final _reg = RegExp(r'^\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;
    if (!_reg.hasMatch(text)) return oldValue;

    // prevent "...." or multiple dots
    final dotCount = '.'.allMatches(text).length;
    if (dotCount > 1) return oldValue;

    return newValue;
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}
