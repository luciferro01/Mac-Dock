import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_dock/features/dock/controller/dock_controller.dart';
import 'package:macos_dock/models/icon_model.dart';

class DraggableIcon extends StatelessWidget {
  final int index;
  final IconDataModel iconData;
  final int? hoveredIndex;

  const DraggableIcon({
    required this.index,
    required this.iconData,
    required this.hoveredIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DockController controller = Get.find<DockController>();
    const double baseItemHeight = 48.0;
    const double maxSize = 70.0;
    const double baseTranslationY = 0.0;
    const double maxTranslationY = -22.0;

    double getScaledSize(double distance) {
      if (hoveredIndex == null) return baseItemHeight;

      double distanceFactor = 1 - (distance.abs() / 2);
      distanceFactor = distanceFactor.clamp(0.0, 1.0);

      return baseItemHeight + (maxSize - baseItemHeight) * distanceFactor;
    }

    double getTranslationY(double size) {
      return baseTranslationY +
          (maxTranslationY - baseTranslationY) *
              ((size - baseItemHeight) / (maxSize - baseItemHeight));
    }

    return Obx(() {
      final dragPosition = controller.dragPosition.value;
      final isBeingDragged = controller.draggingIndex.value == index;

      return LongPressDraggable<IconDataModel>(
        data: iconData,
        dragAnchorStrategy: (draggable, context, position) {
          return const Offset(maxSize / 2, maxSize / 2);
        },
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: maxSize,
            height: maxSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black45,
            ),
            child: Center(
              child: Icon(iconData.icon, color: Colors.white, size: 32),
            ),
          ),
        ),
        childWhenDragging: const SizedBox(
          width: baseItemHeight,
          height: baseItemHeight,
        ),
        onDragStarted: () {
          controller.startDragging(index);
        },
        onDragEnd: (details) {
          // Remove item if dropped outside
          if (!details.wasAccepted && controller.items.length > 1) {
            controller.removeItem(index);
          }
          controller.resetDrag();
        },
        onDraggableCanceled: (velocity, offset) {
          controller.resetDrag();
        },
        child: DragTarget<IconDataModel>(
          builder: (context, candidateData, rejectedData) {
            double distance = hoveredIndex != null
                ? (index - hoveredIndex!).toDouble()
                : double.infinity;
            double size = getScaledSize(distance);

            double shiftOffset = controller.getItemOffset(index, dragPosition);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(shiftOffset, getTranslationY(size), 0.0),
              child: Container(
                height: size,
                width: size,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isBeingDragged
                      ? Colors.transparent
                      : Colors.primaries[
                          iconData.icon.hashCode % Colors.primaries.length],
                ),
                child: Center(
                  child: Icon(
                    iconData.icon,
                    color: Colors.white,
                    size: isBeingDragged ? 0 : null,
                  ),
                ),
              ),
            );
          },
          onWillAcceptWithDetails: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.offset);
            bool isOnRightHalf = localPosition.dx > box.size.width / 2;

            int targetIndex = index;
            if (isOnRightHalf) {
              targetIndex += 1;
            }

            controller.updateDragPosition(
                details.offset.dx / (baseItemHeight + 16), targetIndex);
            return true;
          },
          onAcceptWithDetails: (details) {
            final data = details.data;
            final oldIndex = controller.items.indexOf(data);

            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.offset);
            bool isOnRightHalf = localPosition.dx > box.size.width / 2;

            int newIndex = index;
            if (isOnRightHalf) {
              newIndex += 1;
            }

            if (newIndex > controller.items.length) {
              newIndex = controller.items.length;
            }

            controller.reorderItem(oldIndex, newIndex);
          },
        ),
      );
    });
  }
}
