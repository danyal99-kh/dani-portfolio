import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/project.dart';
import '../utils/responsive.dart';
import 'project_card.dart';

class AnimatedProjectCard extends StatefulWidget {
  const AnimatedProjectCard({
    super.key,
    required this.project,
    required this.index,
    this.delay = Duration.zero,
  });

  final Project project;
  final int index;
  final Duration delay;

  @override
  State<AnimatedProjectCard> createState() => _AnimatedProjectCardState();
}

class _AnimatedProjectCardState extends State<AnimatedProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _entrance;
  ScrollPosition? _scrollPosition;
  Timer? _delayTimer;
  bool _started = false;
  bool _visible = false;
  bool _checkScheduled = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _entrance = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = context.reduceMotion;
    if (reduceMotion != _reduceMotion) {
      _reduceMotion = reduceMotion;
      if (reduceMotion && !_started) {
        _started = true;
        _visible = true;
        _controller.value = 1;
        _removeScrollListener();
        return;
      }
    }

    if (_started) return;
    final position = Scrollable.maybeOf(context)?.position;
    if (!identical(position, _scrollPosition)) {
      _removeScrollListener();
      _scrollPosition = position;
      _scrollPosition?.addListener(_scheduleCheck);
    }
    _scheduleCheck();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _removeScrollListener();
    _controller.dispose();
    super.dispose();
  }

  void _removeScrollListener() {
    _scrollPosition?.removeListener(_scheduleCheck);
    _scrollPosition = null;
  }

  void _scheduleCheck() {
    if (_checkScheduled || _started || !mounted) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (_started || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) {
      _scheduleCheck();
      return;
    }
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final viewportLimit = MediaQuery.sizeOf(context).height * 0.94;
    if (bottom > 0 && top < viewportLimit) {
      _visible = true;
      _removeScrollListener();
      _delayTimer = Timer(widget.delay, () {
        if (!mounted || _started) return;
        _started = true;
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, child) {
        final value = _visible ? _entrance.value : 0.0;
        return IgnorePointer(
          ignoring: value < 0.01,
          child: Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 22),
              child: Transform.scale(
                scale: 0.985 + (0.015 * value),
                child: child,
              ),
            ),
          ),
        );
      },
      child: ProjectCard(
        project: widget.project,
        index: widget.index,
        entrance: _entrance,
      ),
    );
  }
}
