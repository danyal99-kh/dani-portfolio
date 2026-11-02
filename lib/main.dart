import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/app_state.dart';
import 'app/localization/app_localizations.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';

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
  });

  final AppState state;
  final String initialLocation;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final _router = buildRouter(initialLocation: widget.initialLocation);

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
          ),
        );
      },
    );
  }
}
