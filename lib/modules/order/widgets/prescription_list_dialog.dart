import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'prescription_viewer.dart';

class PrescriptionListDialog extends StatelessWidget {
  final List<String> urls;

  const PrescriptionListDialog({super.key, required this.urls});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    final safeUrls = urls
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Dialog(
      insetPadding: EdgeInsets.all(12.w),
      backgroundColor: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              color: _primary,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Prescriptions (${safeUrls.length})',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: Get.back,
                    child: Icon(Icons.close, size: 20.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: safeUrls.isEmpty
                  ? Center(
                      child: Text(
                        'No prescription found',
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(12.w),
                      child: GridView.builder(
                        itemCount: safeUrls.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.w,
                        ),
                        itemBuilder: (_, i) {
                          final url = safeUrls[i];

                          return InkWell(
                            onTap: () {
                              Get.dialog(
                                PrescriptionViewer(
                                  urls: safeUrls,
                                  initialIndex: i,
                                ),
                                barrierColor: Colors.black.withOpacity(0.9),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                color: const Color(0xFFEFF1F6),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    alignment: Alignment.center,
                                    color: const Color(0xFFEFF1F6),
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 22.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                      child: SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
