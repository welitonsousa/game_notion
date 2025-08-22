import 'package:fast_ui_kit/ui/widgets/button.dart';
import 'package:fast_ui_kit/ui/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/core/constants/icon_list.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/modules/states_list/states_list_controller.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FormStateItemDialog extends StatefulWidget {
  final GameItemListModel? item;
  const FormStateItemDialog({super.key, this.item});

  @override
  State<FormStateItemDialog> createState() => _FormStateItemDialogState();
}

class _FormStateItemDialogState extends State<FormStateItemDialog> {
  final form = GlobalKey<FormState>();
  final controllerName = TextEditingController();
  final controllerId = TextEditingController();
  final controllerSearchIcon = TextEditingController();
  IconData? selectedIcon;

  var filteredIcons = [...listIcons];

  @override
  void dispose() {
    controllerName.dispose();
    controllerId.dispose();
    controllerSearchIcon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controllerName.text = widget.item?.name ?? '';
    controllerId.text = widget.item?.id.toString() ?? '';
    selectedIcon = widget.item?.icon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Detalhes da lista',
                        style: TextStyle(fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.item != null)
                      IconButton(
                        onPressed: () {
                          final controller = Get.find<StatesListController>();
                          controller.deleteItem(widget.item!.id);
                          Get.back();
                          Get.snackbar(
                            'Sucesso',
                            'Sua lista foi removida',
                            colorText: Colors.white,
                            backgroundColor: Colors.red,
                          );
                        },
                        color: Colors.red,
                        icon: const Icon(Icons.delete),
                      ),
                  ],
                ),
                if (selectedIcon != null)
                  Icon(selectedIcon, size: 50)
                else
                  const SizedBox(height: 50),
                const SizedBox(height: 10),
                FastFormField(
                  label: 'Nome',
                  radius: 6,
                  validator: Zod().required().max(20).build,
                  controller: controllerName,
                ),
                const SizedBox(height: 10),
                FastFormField(
                  label: 'ID',
                  radius: 6,
                  validator: Zod()
                      .required()
                      .custom((e) {
                        var states = UserSettingsController.i.states;
                        var i = states.indexWhere((s) => s.id == int.parse(e));
                        if (i != -1) {
                          if (widget.item?.id == states[i].id) return true;
                          return false;
                        }
                        return true;
                      }, errorMessage: 'ID já existe')
                      .max(3)
                      .build,
                  mask: [
                    Mask.generic(masks: ['###'])
                  ],
                  controller: controllerId,
                ),
                const SizedBox(height: 10),
                FastFormField(
                  label: 'Pesquisar icone',
                  radius: 6,
                  validator: Zod().custom((e) {
                    if (selectedIcon == null) return false;
                    return true;
                  }, errorMessage: 'Campo obrigatório').build,
                  controller: controllerSearchIcon,
                  onChanged: (value) {
                    filteredIcons =
                        listIcons.where((e) => e.contains(value)).toList();
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: filteredIcons.length,
                      itemBuilder: (c, i) {
                        final name = filteredIcons[i];
                        final icon = SymbolsGet.get(name, SymbolStyle.sharp);
                        if (selectedIcon?.codePoint == icon.codePoint) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(icon),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            selectedIcon = icon;
                            setState(() {});
                          },
                          child: Icon(icon),
                        );
                      }),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FastButton(
                        label: 'Cancelar',
                        background: Colors.red,
                        onPressed: Get.back,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FastButton(
                          label: 'Salvar',
                          onPressed: () {
                            if (form.currentState?.validate() ?? false) {
                              final controller =
                                  Get.find<StatesListController>();
                              final item = GameItemListModel(
                                name: controllerName.text,
                                id: int.parse(controllerId.text),
                                icon: selectedIcon ?? Symbols.abc,
                              );
                              if (widget.item != null) {
                                controller.updateItem(item);
                              } else {
                                controller.addItem(item);
                              }
                              Get.back();
                              Get.snackbar(
                                'Sucesso',
                                'Sua lista foi salva',
                                colorText: Colors.white,
                                backgroundColor: Colors.green,
                              );
                            }
                          }),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
