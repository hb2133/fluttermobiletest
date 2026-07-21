import 'package:flutter/material.dart';

import 'package:fluttermobiletest/app/panel_layer/panel_layer_host.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_controller.dart';
import 'package:fluttermobiletest/panels/base/rock_home/sections/rock_garden/rock_garden_section.dart';

class RockHomePanel extends StatefulWidget {
  const RockHomePanel({super.key});

  @override
  State<RockHomePanel> createState() => _RockHomePanelState();
}

class _RockHomePanelState extends State<RockHomePanel> {
  late final RockHomeController _Controller;

  @override
  void initState() {
    super.initState();
    _Controller = RockHomeController();
  }

  @override
  void dispose() {
    _Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PanelLayerHost(
      child: Scaffold(
        key: const Key('rock_home.panel.root'),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _Controller,
            builder: (BuildContext Context, Widget? Child) {
              return RockGardenSection(
                StateValue: _Controller.State,
                TodayPolish: _Controller.TodayPolishAmount(),
                IsDailyLimitReached: _Controller.IsDailyLimitReached(),
                OnPetStart: _Controller.HandlePetStart,
                OnPetProgress: _Controller.HandlePetProgress,
                OnPetComplete: _Controller.HandlePetComplete,
                OnPetCancel: _Controller.HandlePetCancel,
                OnCheatReset: _Controller.ResetProgress,
              );
            },
          ),
        ),
      ),
    );
  }
}
