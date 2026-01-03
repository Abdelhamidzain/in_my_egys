import 'package:flutter/material.dart';

class EditMedicationScreen extends StatelessWidget {
  final String medicationId;
  const EditMedicationScreen({super.key, required this.medicationId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Medication')),
      body: Center(child: Text('Coming Soon')),
    );
  }
}
