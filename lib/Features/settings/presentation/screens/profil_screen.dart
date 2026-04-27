import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Core/widgets/head_line_texte.dart';
import 'package:suivi_budget/Features/settings/logic/providers/user_prefs_provider.dart';
import 'package:suivi_budget/Features/settings/presentation/widgets/edit_username_bottom_sheet.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/Core/widgets/custom_filled_button_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: couleurbgSecondaire,
                child: Icon(Icons.person, size: 40, color: couleurRevenu),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<UserPrefsProvider>(
                    builder: (context, value, child) {
                      return HeadLineTexte(
                        texte: value.userInfos ?? "Non définit",
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => EditUsernameBottomSheet(),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              Spacer(),
              CustomFilledButtonWidget(
                texte: "Deconnecter",
                action: () {},
                chargement: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
