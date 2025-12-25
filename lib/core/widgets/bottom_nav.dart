import 'package:drug/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D2EBE),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D2EBE),
        elevation: 0,

        currentIndex: currentIndex, // ✅ ACTIVE TAB
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,

        selectedFontSize: 12,
        unselectedFontSize: 12,

        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              Get.offAllNamed(Routes.dashboard);
              break;
            case 1:
              Get.offAllNamed(Routes.order);
              break;
            case 2:
              Get.offAllNamed(Routes.addList);
              break;
            case 3:
              Get.offAllNamed(Routes.allList);
              break;
          }
        },

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
      ),
    );
  }
}
