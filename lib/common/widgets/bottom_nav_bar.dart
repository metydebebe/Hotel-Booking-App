import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_reservation/screens/home_screen.dart';
import 'package:hotel_reservation/screens/hotels_screen.dart';
import 'package:hotel_reservation/screens/saved_screen.dart';
import 'package:hotel_reservation/screens/setting_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 3,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(LineAwesomeIcons.hotel), label: 'Hotels'),
              NavigationDestination(
                  icon: Icon(CupertinoIcons.heart), label: 'Saved'),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    HotelsScreen(),
    SavedScreen(),
    const SettingScreen()
  ];
}
