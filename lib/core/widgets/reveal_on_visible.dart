import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'welcome_gate.dart';

/// Entrance animation (fade + slide + slight scale) that starts only when the
/// widget is in the viewport, the welcome overlay is gone, and the page
/// transition is mostly finished.
class RevealOnVisible extends StatefulWidget {
  const RevealOnVisible({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.offset = const Offset(0, 0.08),
    this.scaleBegin = 0.97,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double scaleBegin;

  @override
  State<RevealOnVisible> createState() => _RevealOnVisibleState();
}

class _RevealOnVisibleState extends State<RevealOnVisible>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  ScrollPosition? _position;
  Animation<double>? _routeAnim;
  Timer? _timer;
  bool _started = false;
  bool _blocked = false;
  bool _checkScheduled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: widget.scaleBegin, end: 1).animate(curve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;

    if (context.reduceMotion) {
      _started = true;
      _controller.value = 1;
      _detach();
      return;
    }

    _blocked = WelcomeGate.isActive(context);
    MediaQuery.sizeOf(context); // re-check on resize

    final route = ModalRoute.of(context)?.animation;
    if (!identical(route, _routeAnim)) {
      _routeAnim?.removeListener(_scheduleCheck);
      _routeAnim = route;
      _routeAnim?.addListener(_scheduleCheck);
    }

    final position = Scrollable.maybeOf(context)?.position;
    if (!identical(position, _position)) {
      _position?.removeListener(_scheduleCheck);
      _position = position;
      _position?.addListener(_scheduleCheck);
    }
    _scheduleCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _detach();
    _controller.dispose();
    super.dispose();
  }

  void _detach() {
    _position?.removeListener(_scheduleCheck);
    _position = null;
    _routeAnim?.removeListener(_scheduleCheck);
    _routeAnim = null;
  }

  void _scheduleCheck() {
    if (_checkScheduled || _started || !mounted) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      _check();
    });
  }

  void _check() {
    if (_started || !mounted || _blocked) return;
    // صبر کن تا انیمیشن ورود صفحه تقریباً تمام شود
    if ((_routeAnim?.value ?? 1.0) < 0.6) return;

    final ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) return;

    final top = ro.localToGlobal(Offset.zero).dy;
    final bottom = top + ro.size.height;
    final limit = MediaQuery.sizeOf(context).height * 0.92;

    if (bottom > 0 && top < limit) {
      _started = true;
      _detach();
      _timer = Timer(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
