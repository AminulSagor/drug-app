import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../modules/auth/login/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showBlockingLoader() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // ✅ back button disabled
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(strokeWidth: 3),
                ),
                12.horizontalSpace,
                Text(
                  'Logging out...',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D2EBE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // ✅ tap outside disabled
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  void _closeLoaderIfOpen() {
    if (Get.isDialogOpen == true) {
      Get.back(); // closes loader dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Drawer(
      width: 150.w,
      backgroundColor: const Color(0xFFF2F2F2),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Column(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFF0D2EBE),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              8.verticalSpace,
              Obx(() {
                final u = auth.user.value;
                return Text(
                  u?.fullName.isNotEmpty == true ? u!.fullName : 'User',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D2EBE),
                  ),
                );
              }),
            ],
          ),
          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF0D2EBE)),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D2EBE),
              ),
            ),
            onTap: () async {
              Navigator.of(context).pop(); // close drawer

              _showBlockingLoader();

              try {
                await auth.logout();
              } catch (_) {
                // optional snackbar (only if you want)
                // Get.snackbar('Error', 'Logout failed. Please try again.');
              } finally {
                _closeLoaderIfOpen();
              }
            },
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
