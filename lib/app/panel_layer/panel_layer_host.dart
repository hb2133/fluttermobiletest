import 'package:flutter/widgets.dart';

class PanelLayerHost extends StatelessWidget {
  const PanelLayerHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
