import 'package:flutter/material.dart';

import 'package:fluttermobiletest/design/global_design.dart';
import 'package:fluttermobiletest/panels/base/rock_home/rock_home_panel.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '화면 속 돌멩이',
      theme: GlobalDesign.Theme,
      home: const RockHomePanel(),
    );
  }
}
