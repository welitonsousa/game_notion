import 'package:get/get.dart';
import './states_list_controller.dart';

class StatesListBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(StatesListController());
    }
}