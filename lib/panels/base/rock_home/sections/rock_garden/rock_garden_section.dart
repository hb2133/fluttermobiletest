import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fluttermobiletest/core/localization/app_strings.dart';
import 'package:fluttermobiletest/design/global_design.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_state.dart';
import 'package:fluttermobiletest/panels/base/rock_home/controller/rock_home_types.dart';

class RockGardenSection extends StatefulWidget {
  const RockGardenSection({
    super.key,
    required this.StateValue,
    required this.TodayPolish,
    required this.IsDailyLimitReached,
    required this.OnPetStart,
    required this.OnPetProgress,
    required this.OnPetComplete,
    required this.OnPetCancel,
    required this.OnCheatReset,
  });

  final RockHomeState StateValue;
  final int TodayPolish;
  final bool IsDailyLimitReached;
  final VoidCallback OnPetStart;
  final void Function(double Distance) OnPetProgress;
  final Future<void> Function() OnPetComplete;
  final VoidCallback OnPetCancel;
  final Future<void> Function() OnCheatReset;

  @override
  State<RockGardenSection> createState() => _RockGardenSectionState();
}

class _RockGardenSectionState extends State<RockGardenSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _GlowController;
  Offset _TouchPosition = const Offset(0.38, 0.28);
  double _Tilt = 0;

  @override
  void initState() {
    super.initState();
    _GlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void didUpdateWidget(covariant RockGardenSection OldWidget) {
    super.didUpdateWidget(OldWidget);
    if (OldWidget.StateValue.ReactionToken != widget.StateValue.ReactionToken) {
      _GlowController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _GlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext Context, BoxConstraints Constraints) {
        final bool IsCompactHeight = Constraints.maxHeight < 690;
        final double TopPadding = IsCompactHeight == true ? 18 : 30;
        const double BottomPadding = 24;
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, TopPadding, 24, BottomPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: math.max(0, Constraints.maxWidth - 48),
                  minHeight: math.max(
                    0,
                    Constraints.maxHeight - TopPadding - BottomPadding,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const _Header(),
                    _BuildRockStage(Context),
                    _StatusGroup(
                      StatusText: _StatusText(),
                      TodayPolish: widget.TodayPolish,
                      IsDailyLimitReached: widget.IsDailyLimitReached,
                      ReactionToken: widget.StateValue.ReactionToken,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: ExcludeSemantics(
                child: GestureDetector(
                  key: const Key('rock.cheat.reset'),
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.OnCheatReset,
                  child: const SizedBox(width: 48, height: 48),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _BuildRockStage(BuildContext Context) {
    return Semantics(
      button: true,
      label: AppStrings.PetSemantics,
      child: MouseRegion(
        cursor: widget.StateValue.IsPetting == true
            ? SystemMouseCursors.grabbing
            : widget.IsDailyLimitReached == true
            ? SystemMouseCursors.basic
            : SystemMouseCursors.grab,
        child: GestureDetector(
          key: const Key('rock.garden.character'),
          behavior: HitTestBehavior.opaque,
          onPanStart: (DragStartDetails Details) {
            _UpdateTouch(Details.localPosition, const Size(300, 240));
            widget.OnPetStart();
          },
          onPanUpdate: (DragUpdateDetails Details) {
            _UpdateTouch(Details.localPosition, const Size(300, 240));
            widget.OnPetProgress(Details.delta.distance);
            setState(() {
              _Tilt = (Details.delta.dx / 180).clamp(-0.025, 0.025);
            });
          },
          onPanEnd: (DragEndDetails Details) {
            setState(() {
              _Tilt = 0;
            });
            widget.OnPetComplete();
          },
          onPanCancel: () {
            setState(() {
              _Tilt = 0;
            });
            widget.OnPetCancel();
          },
          child: AnimatedBuilder(
            animation: _GlowController,
            builder: (BuildContext Context, Widget? Child) {
              final double Pulse = math.sin(_GlowController.value * math.pi);
              return Transform.rotate(
                angle: _Tilt,
                child: Transform.scale(
                  scale: 1 + (Pulse * 0.025),
                  child: _RockVisual(
                    Shine: widget.StateValue.Shine,
                    DailyProgress:
                        widget.TodayPolish / RockCarePolicy.DailyPolishTarget,
                    TouchPosition: _TouchPosition,
                    IsTouching: widget.StateValue.IsPetting,
                    FeedbackStrength: widget.StateValue.IsPetting == true
                        ? 0.55
                        : Pulse,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _UpdateTouch(Offset Position, Size StageSize) {
    setState(() {
      _TouchPosition = Offset(
        (Position.dx / StageSize.width).clamp(0, 1),
        (Position.dy / StageSize.height).clamp(0, 1),
      );
    });
  }

  String _StatusText() {
    if (widget.StateValue.IsLoading == true) {
      return '돌멩이를 바라보는 중';
    }
    if (widget.StateValue.TotalPolish == 0) {
      return AppStrings.FirstDay;
    }
    if (widget.IsDailyLimitReached == true) {
      return AppStrings.DailyDone;
    }
    return AppStrings.ShineFeedback;
  }
}

class _StatusGroup extends StatelessWidget {
  const _StatusGroup({
    required this.StatusText,
    required this.TodayPolish,
    required this.IsDailyLimitReached,
    required this.ReactionToken,
  });

  final String StatusText;
  final int TodayPolish;
  final bool IsDailyLimitReached;
  final int ReactionToken;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Text(
            StatusText,
            key: ValueKey<String>('$StatusText.$ReactionToken'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          IsDailyLimitReached == true
              ? AppStrings.ComeBackTomorrow
              : AppStrings.PetHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 15),
        _DailyPetProgress(TodayPolish: TodayPolish),
        const SizedBox(height: 24),
        const _QuietFooter(),
      ],
    );
  }
}

class _DailyPetProgress extends StatelessWidget {
  const _DailyPetProgress({required this.TodayPolish});

  final int TodayPolish;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '오늘 쓰다듬기 ${(TodayPolish / RockCarePolicy.DailyPolishTarget * 100).round()}퍼센트',
      child: SizedBox(
        width: 250,
        child: Column(
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.DailyProgress,
                style: TextStyle(
                  color: GlobalDesign.SoftInk,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                end: TodayPolish / RockCarePolicy.DailyPolishTarget,
              ),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (BuildContext Context, double Progress, Widget? Child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    key: const Key('rock.daily_pet.progress'),
                    value: Progress,
                    minHeight: 10,
                    backgroundColor: GlobalDesign.Mist,
                    color: GlobalDesign.Moss,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            AppStrings.AppTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.AppSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _QuietFooter extends StatelessWidget {
  const _QuietFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: GlobalDesign.Mist.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Text(
        AppStrings.QuietPromise,
        style: TextStyle(
          color: GlobalDesign.SoftInk,
          fontSize: 13,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _RockVisual extends StatelessWidget {
  const _RockVisual({
    required this.Shine,
    required this.DailyProgress,
    required this.TouchPosition,
    required this.IsTouching,
    required this.FeedbackStrength,
  });

  final double Shine;
  final double DailyProgress;
  final Offset TouchPosition;
  final bool IsTouching;
  final double FeedbackStrength;

  @override
  Widget build(BuildContext context) {
    final Alignment TouchCenter = Alignment(
      (TouchPosition.dx * 2) - 1,
      (TouchPosition.dy * 2) - 1,
    );
    final double VisualShine = ((Shine * 0.45) + (DailyProgress * 0.72)).clamp(
      0,
      1,
    );
    final double Brightness = 0.68 + (VisualShine * 0.5);
    final double PermanentShineOpacity = 0.04 + (VisualShine * 0.72);

    return SizedBox(
      width: 300,
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 22,
            child: Container(
              width: 215,
              height: 35,
              decoration: BoxDecoration(
                color: GlobalDesign.Ink.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(99),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: GlobalDesign.Ink.withValues(alpha: 0.18),
                    blurRadius: 22,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Transform.scale(
            scale: 1.24,
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(<double>[
                Brightness,
                0,
                0,
                0,
                0,
                0,
                Brightness,
                0,
                0,
                0,
                0,
                0,
                Brightness,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: Image.asset(
                'assets/images/river_stone.png',
                width: 300,
                height: 240,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          _StoneHighlight(
            Center: const Alignment(-0.38, -0.42),
            Radius: 0.82,
            OpacityValue: PermanentShineOpacity,
          ),
          if (IsTouching == true)
            _StoneHighlight(
              key: const Key('rock.touch.highlight'),
              Center: TouchCenter,
              Radius: 0.38,
              OpacityValue: 0.68,
            ),
          if (FeedbackStrength > 0.02) ...<Widget>[
            Positioned(
              left: 68,
              top: 70,
              child: _Sparkle(OpacityValue: FeedbackStrength),
            ),
            Positioned(
              right: 72,
              top: 84,
              child: _Sparkle(OpacityValue: FeedbackStrength * 0.72),
            ),
          ],
        ],
      ),
    );
  }
}

class _StoneHighlight extends StatelessWidget {
  const _StoneHighlight({
    super.key,
    required this.Center,
    required this.Radius,
    required this.OpacityValue,
  });

  final Alignment Center;
  final double Radius;
  final double OpacityValue;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: OpacityValue.clamp(0, 1),
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (Rect Bounds) {
          return RadialGradient(
            center: Center,
            radius: Radius,
            colors: const <Color>[Colors.white, Colors.transparent],
          ).createShader(Bounds);
        },
        child: Transform.scale(
          scale: 1.24,
          child: Image.asset(
            'assets/images/river_stone.png',
            width: 300,
            height: 240,
            fit: BoxFit.contain,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.OpacityValue});

  final double OpacityValue;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: OpacityValue.clamp(0, 1),
      child: Transform.scale(
        scale: 0.8 + (OpacityValue * 0.45),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 34,
          shadows: <Shadow>[
            Shadow(color: GlobalDesign.Moss, blurRadius: 12),
            Shadow(color: GlobalDesign.WarmLight, blurRadius: 5),
          ],
        ),
      ),
    );
  }
}
