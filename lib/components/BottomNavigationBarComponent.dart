import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_application/controllers/navigation_controller.dart';

class BottomNavigationBarComponent extends StatelessWidget {
  const BottomNavigationBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController nc = Get.find();
    return Obx(
      () {
        return BottomNavigationBar(
          currentIndex: nc.currentPageIndex.value,
          selectedItemColor: Colors.amber,
          onTap: (index) {
            nc.setPageIndex(index);
            Get.offNamed(nc.listPage[index]);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: "Profile",
            ),
          ],
        );
      },
    );
  }
}
