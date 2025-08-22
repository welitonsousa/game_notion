import 'package:flutter/material.dart';
import 'package:game_notion/modules/states_list/form_state_item_dialog.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';

import './states_list_controller.dart';

class StatesListPage extends GetView<StatesListController> {
  const StatesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listas de games')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const FormStateItemDialog());
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        return ReorderableColumn(
          onReorder: controller.reorderList,
          children: controller.listGamesState.map((e) {
            return ListTile(
                onTap: () {
                  Get.dialog(FormStateItemDialog(item: e));
                },
                leading: Icon(e.icon),
                key: ValueKey(e.id),
                title: Text(e.name),
                trailing: const Icon(Icons.list));
          }).toList(),
        );
      }),
    );
  }
}
