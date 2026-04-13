import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/widgets/list_tile_widget.dart';
import 'package:suivi_budget/Features/settings/presentation/screens/profil_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          spacing: 12,
          children: [
            ListTileWidget(
              texte: "Profile",
              icone: Icons.person,
              action: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
