import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'core/storage/auth_storage.dart';
import 'modules/auth/login/auth_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // ✅ Put controller BEFORE deciding route, then hydrate it
  final auth = Get.put(AuthController(), permanent: true);
  await auth.restoreSession();

  // ✅ Decide initial route using token (same as you want)
  final token = await AuthStorage().readToken();
  final initialRoute = (token != null && token.trim().isNotEmpty)
      ? Routes.dashboard
      : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drug',
          theme: ThemeData(
            primaryColor: const Color(0xFF0D2EBE),
            scaffoldBackgroundColor: Colors.white,
          ),
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
