import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/deconnexion_provider.dart';
import 'package:suivi_budget/Providers/Preferences%20provider/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final utilisateurInfos = Provider.of<UtilisateurPreferencesProvider>(
      context,
      listen: false,
    );

    return SafeArea(
      child: FutureBuilder(
        future: utilisateurInfos.chargerNom(),
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
              GestureDetector(
                onTap: () => UtilisateurPreferencesProvider().chargerNom(),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Styles.couleurbgSecondaire,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Styles.couleurRevenu,
                  ),
                ),
              ),
              headTextWidget(
                texte: "${utilisateurInfos.nom} ${utilisateurInfos.prenom}",
              ),
              descriptionText(text: "${utilisateurInfos.email}"),
              Gap(22),
              Consumer<DeconnexionProvider>(
                builder: (context, value, child) => CustomFilledButtonWidget(
                  texte: "Deconnecter",
                  action: () => context
                      .read<DeconnexionProvider>()
                      .deconnecterUtilisateur(context),
                  chargement: value.chargement,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
