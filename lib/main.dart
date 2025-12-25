import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drug',

          /// 🎯 THEME
          theme: ThemeData(
            primaryColor: const Color(0xFF0D2EBE),
            scaffoldBackgroundColor: Colors.white,
          ),

          /// 🚀 ROUTING (GetX)
          initialRoute: Routes.login,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
