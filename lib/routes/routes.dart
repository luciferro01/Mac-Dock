import 'package:get/get.dart';
import 'package:macos_dock/bindings/bindings.dart';
import 'package:macos_dock/features/detail/view/detail_view.dart';
import 'package:macos_dock/features/dock/view/dock_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      binding: DockBinding(),
      page: () => const DockScreen(),
    ),
    GetPage(name: '/person', page: () => const DetailScreen(title: 'Person')),
    GetPage(name: '/message', page: () => const DetailScreen(title: 'Message')),
    GetPage(name: '/call', page: () => const DetailScreen(title: 'Call')),
    GetPage(name: '/camera', page: () => const DetailScreen(title: 'Camera')),
    GetPage(name: '/photo', page: () => const DetailScreen(title: 'Photo')),
  ];
}
