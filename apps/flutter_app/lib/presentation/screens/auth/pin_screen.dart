import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carecompanion/l10n/generated/app_localizations.dart';
import '../../../core/router/app_router.dart';

class PinScreen extends ConsumerStatefulWidget {
  const PinScreen({super.key});

  @override
  ConsumerState<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<PinScreen> {
  final _pinController = TextEditingController();
  
  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.primary),
              SizedBox(height: 24),
              Text(l10n.enterPin, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 32),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, letterSpacing: 16),
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.length == 4) {
                    // Verify PIN
                    context.go(AppRoutes.today);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
