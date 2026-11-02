import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/localization/app_localizations.dart';
import '../core/utils/responsive.dart';
import '../core/widgets/empty_state.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ContentContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 90),
        child: EmptyState(
          icon: Icons.explore_off_outlined,
          title: l10n.t('notFound.title'),
          message: l10n.t('notFound.message'),
          actionLabel: l10n.t('common.backHome'),
          onAction: () => context.go('/'),
        ),
      ),
    );
  }
}
