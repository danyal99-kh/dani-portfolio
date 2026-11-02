import 'package:flutter/material.dart';

import 'ambient_background.dart';
import 'app_drawer.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant PortfolioShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location && _scrollController.hasClients) {
      _scrollController.jumpTo(0);
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: AppDrawer(location: widget.location),
      body: AmbientBackground(
        child: Column(
          children: [
            AppHeader(
              location: widget.location,
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.child,
                      AppFooter(onBackToTop: _scrollToTop),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
