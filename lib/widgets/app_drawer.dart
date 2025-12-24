import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 150.w,
      backgroundColor: const Color(0xFFF2F2F2),
      child: Column(
        children: [
          SizedBox(height: 48.h),

          /// 👤 PROFILE SECTION
          Column(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFF0D2EBE),
                child: const Icon(Icons.person, color: Colors.white),
              ),

              8.verticalSpace,

              Text(
                'Fazle Hasan \nKabir',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D2EBE),
                ),
              ),


            ],
          ),

          const Spacer(),

          /// 🚪 LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF0D2EBE)),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D2EBE),
              ),
            ),
            onTap: () {
              Get.offAllNamed('/login');
            },
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
