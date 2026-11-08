import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/app_state.dart';
import 'app/localization/app_localizations.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/widgets/terminal_welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  runApp(PortfolioApp(state: state));
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({
    super.key,
    required this.state,
    this.initialLocation = '/',
    this.showWelcome = true,
  });

  final AppState state;
  final String initialLocation;
  final bool showWelcome;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final _router = buildRouter(initialLocation: widget.initialLocation);
  late bool _showWelcome;
  bool _appReady = false;

  @override
  void initState() {
    super.initState();
    _showWelcome = widget.showWelcome;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _appReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final isFa = widget.state.locale.languageCode == 'fa';
        return AppStateScope(
          state: widget.state,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            theme: AppTheme.light(isFa: isFa),
            darkTheme: AppTheme.dark(isFa: isFa),
            themeMode: widget.state.themeMode,
            locale: widget.state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateTitle: (context) => context.l10n.t('meta.siteTitle'),
            builder: (context, child) {
              final content = child ?? const SizedBox.shrink();
              return Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeFocus(
                    excluding: _showWelcome,
                    child: ExcludeSemantics(
                      excluding: _showWelcome,
                      child: IgnorePointer(
                        ignoring: _showWelcome,
                        child: content,
                      ),
                    ),
                  ),
                  if (_showWelcome)
                    Positioned.fill(
                      child: TerminalWelcomeScreen(
                        isReady: _appReady,
                        onFinished: () {
                          if (mounted) setState(() => _showWelcome = false);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
