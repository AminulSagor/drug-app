import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/top_and_nav_bar/top_and_bottom_bar_controller.dart';

class AppBottomNav extends GetView<TopAndBottomBarController> {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D2EBE),
      child: Obx(() {
        final currentIndex = controller.currentIndex.value;

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D2EBE),
          elevation: 0,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: controller.onTabTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add-List',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All-List'),
          ],
        );
      }),
    );
  }
}
