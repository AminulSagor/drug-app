import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuTap;
  final Widget? leading;
  final Widget? trailing;

  const AppHeader({
    super.key,
    required this.title,
    this.onMenuTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: const Color(0xFF0D2EBE),
      child: Row(
        children: [
          /// LEFT
          leading ??
              InkWell(
                onTap: onMenuTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Image.asset(
                    'assets/drawer_icon.png',
                    width: 22.w,
                    color: Colors.white,
                  ),
                ),
              ),

          const Spacer(),

          /// TITLE
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          /// RIGHT
          trailing ?? SizedBox(width: 22.w),
        ],
      ),
    );
  }
}
