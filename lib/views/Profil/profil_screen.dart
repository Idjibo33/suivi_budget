import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Functions/charger_doc_utilisateur.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_utilisateur_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      texte:
                          "${value.utilisateur?.prenom} ${value.utilisateur?.nom}",
                    ),
                    descriptionText(text: value.utilisateur!.email),
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
