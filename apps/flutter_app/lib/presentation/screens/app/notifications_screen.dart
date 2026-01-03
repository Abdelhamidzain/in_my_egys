import 'package:flutter/material.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: Center(child: Text('Coming Soon')),
    );
  }
}
