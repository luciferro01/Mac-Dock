import 'package:flutter/material.dart';
import '../widgets/dock_widget.dart';

class DockScreen extends StatelessWidget {
  const DockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DockWidget(),
      ),
    );
  }
}
