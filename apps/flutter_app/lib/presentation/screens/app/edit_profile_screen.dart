import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final String profileId;
  const EditProfileScreen({super.key, required this.profileId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Center(child: Text('Coming Soon')),
    );
  }
}
