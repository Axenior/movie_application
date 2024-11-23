import 'package:get/get.dart';

class NavigationController extends GetxController {
  List<String> listPage = ['/', '/profile'];

  RxInt currentPageIndex = 0.obs;

  void setPageIndex(int index) {
    currentPageIndex.value = index;
  }
}
