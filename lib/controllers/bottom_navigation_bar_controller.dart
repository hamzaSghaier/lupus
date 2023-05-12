import 'package:get/get.dart';
import 'package:hospital_app/screens/dashboard.dart';

class BottomNavigationBarController extends GetxController {
  var selectedIndex = 1.obs;

  void changeIndex(int index) => selectedIndex.value = index;
}
