import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Preferences/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/Providers/Supabase%20authentification%20services%20provider/auth_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer2<AuthServicesProvider, UtilisateurPreferencesProvider>(
        builder: (context, auth, utilisateurPrefs, child) => Column(
          children: [
            FutureBuilder(
              future: utilisateurPrefs.loadInfos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        headTextWidget(texte: "profil"),
                        IconButton(
                          onPressed: () => Scaffold.of(context).closeDrawer(),
                          icon: Icon(Icons.menu_open_outlined),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Styles.couleurbgSecondaire,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Styles.couleurRevenu,
                      ),
                    ),
                    headTextWidget(
                      texte: "${snapshot.data[0]} ${snapshot.data[1]}",
                    ),
                    descriptionText(text: "${snapshot.data[2]}"),
                  ],
                );
              },
            ),
            Gap(22),
            CustomFilledButtonWidget(
              texte: "Deconnecter",
              action: () => auth.signUserOut(context: context),
              chargement: auth.chargement,
            ),
          ],
        ),
      ),
    );
  }
}
