import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/Providers/utilisateur_provider.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Le controlleur du champ d'entrée du nom de l'utilisateur
    TextEditingController texte = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Text(
                "Juste quelques étapes rapides pour commencer. Votre vie privée est notre priorité. Nous ne stockons vos données sur aucun serveur externe. Tout reste sur votre appareil.",
                style: Styles.texteCorps,
                textAlign: TextAlign.center,
              ),
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text("Nom complet", style: Styles.texteTitre),
              ),
              TextField(
                controller: texte,
                autofocus: true,
                decoration: InputDecoration(
                  label: Text("ex : Mohamed Ali", style: Styles.texteCorps),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Styles.couleurbgSecondaire,
                ),
              ),
              Text(
                "Remarque : Votre nom n'est utilisé que pour la personnalisation dans l'application (par exemple 'Bienvenue [Nom]'). Il est stocké uniquement sur votre appareil.",
                style: Styles.texteCorps,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    //Enregistrement du nom de l'utilisateur
                    context.read<UtilisateurProvider>().misAJourNom(texte.text);
                    Navigator.pop(context);

                    //Affichage du message de succès
                    showSuccessSnackbar(
                      context,
                      "Succès: Nom d'utilisateur enregistré",
                    );
                  },
                  child: const Text("Continuer"),
                ),
              ),
              Text(
                "En continuant, vous confirmez que vous avez lu et accepté nos conditions",
                style: Styles.texteCorps,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
