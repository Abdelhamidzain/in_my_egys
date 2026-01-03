import 'package:flutter/material.dart';

class CaregiverConsentScreen extends StatelessWidget {
  final String pairCode;
  const CaregiverConsentScreen({super.key, required this.pairCode});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Caregiver Consent')),
      body: Center(child: Text('Coming Soon')),
    );
  }
}
