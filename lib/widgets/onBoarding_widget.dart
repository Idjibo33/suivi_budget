import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/providers.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                    context.read<UtilisateurInfoProvider>().ajouterNom(
                      texte.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Nom enregistré avec succès",
                          style: Styles.texteTitre.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Styles.couleurRevenu,
                        behavior: SnackBarBehavior.floating,
                      ),
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
