import 'package:flutter/material.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';

class AddProfileScreen extends StatelessWidget {
  const AddProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createProfile)),
      body: Center(child: Text('Coming Soon')),
    );
  }
}
