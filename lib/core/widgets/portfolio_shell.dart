import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'ambient_background.dart';
import 'app_footer.dart';
import 'app_header.dart';

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  final _scrollController = ScrollController();
  final _scrolled = ValueNotifier<bool>(false);
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final value = _scrollController.offset > 12;
    if (value != _scrolled.value) _scrolled.value = value;
  }

  @override
  void didUpdateWidget(covariant PortfolioShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _menuOpen = false;
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _scrollController.jumpTo(0);
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);

  void _closeMenu() {
    if (_menuOpen) setState(() => _menuOpen = false);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _scrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menu only exists on mobile; close it if the window grows.
    final menuOpen = _menuOpen && context.isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppHeader.reservedHeight(context)),
                      widget.child,
                      AppFooter(onBackToTop: _scrollToTop),
                    ],
                  ),
                ),
              ),
            ),
            if (menuOpen)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _closeMenu,
                  child: const SizedBox.expand(),
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<bool>(
                valueListenable: _scrolled,
                builder: (context, scrolled, _) => AppHeader(
                  location: widget.location,
                  scrolled: scrolled,
                  menuOpen: menuOpen,
                  onMenuToggle: _toggleMenu,
                  onMenuClose: _closeMenu,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
