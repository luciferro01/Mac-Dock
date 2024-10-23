import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_dock/features/dock/controller/dock_controller.dart';
import 'package:macos_dock/features/dock/widgets/draggable_icon_widget.dart';

class DockWidget extends StatelessWidget {
  const DockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DockController controller = Get.find<DockController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Obx(
        () => Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.items.length,
            (index) => MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => controller.setHoveredIndex(index),
              onExit: (_) => controller.setHoveredIndex(null),
              child: DraggableIcon(
                index: index,
                iconData: controller.items[index],
                hoveredIndex: controller.hoveredIndex.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
