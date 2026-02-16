import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Functions/charger_doc_utilisateur.dart';
import 'package:suivi_budget/Functions/deconnecter_utilisateur.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/deconnexion_services_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_utilisateur_provider.dart';
import 'package:suivi_budget/Providers/Preferences%20provider/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UtilisateurPreferencesProvider utilisateur =
        UtilisateurPreferencesProvider();
    return FutureBuilder(
      future: chargerDocUtilisateur(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Consumer<DocUtilisateurProvider>(
                builder: (context, value, child) => Column(
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
                      texte: "${utilisateur.nom} ${utilisateur.prenom}",
                    ),
                    descriptionText(text: "${utilisateur.email}"),
                    Consumer<DeconnexionServicesProvider>(
                      builder: (context, value, child) =>
                          CustomFilledButtonWidget(
                            texte: "Deconnecter",
                            action: () =>
                                deconnecterUtilisateur(context: context),
                            chargement: value.chargement,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
