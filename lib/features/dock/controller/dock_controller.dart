import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_dock/models/icon_model.dart';

class DockController extends GetxController {
  final RxList<IconDataModel> items = <IconDataModel>[
    IconDataModel(1, Icons.person, '/person'),
    IconDataModel(2, Icons.message, '/message'),
    IconDataModel(3, Icons.call, '/call'),
    IconDataModel(4, Icons.camera, '/camera'),
    IconDataModel(5, Icons.photo, '/photo'),
  ].obs;

  final RxInt dragTargetIndex = (-1).obs;
  final RxDouble dragPosition = 0.0.obs;
  final RxInt draggingIndex = (-1).obs;
  final RxBool isDragging = false.obs;
  final Rxn<int> hoveredIndex = Rxn<int>();

  void updateDragPosition(double position, int targetIndex) {
    dragPosition.value = position;
    dragTargetIndex.value = targetIndex;
  }

  void startDragging(int index) {
    draggingIndex.value = index;
    isDragging.value = true;
  }

  void removeItem(int index) {
    if (index > 0 && index < items.length) {
      items.removeAt(index);
      updateDock();
    }
  }

  void resetDrag() {
    dragPosition.value = 0.0;
    dragTargetIndex.value = -1;
    draggingIndex.value = -1;
    isDragging.value = false;
  }

  void reorderItem(int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    updateDock();
  }

  void updateDock() {
    items.refresh();
  }

  // Handling null properly where intially it would be null as nothing is hovered and after hovering it should be null as well
  void setHoveredIndex(int? index) {
    hoveredIndex.value = index;
  }

  double getItemOffset(int index, double dragX) {
    if (!isDragging.value) return 0;
    final dragIndex = draggingIndex.value;
    if (dragIndex == -1) return 0;
    int targetIndex = dragTargetIndex.value;
    if (targetIndex == dragIndex) return 0;

    const double shiftAmount = 64.0;
    if (targetIndex > dragIndex) {
      if (index > dragIndex && index <= targetIndex) {
        return -shiftAmount;
      }
    } else if (targetIndex < dragIndex) {
      if (index >= targetIndex && index < dragIndex) {
        return shiftAmount;
      }
    }
    return 0;
  }
}
