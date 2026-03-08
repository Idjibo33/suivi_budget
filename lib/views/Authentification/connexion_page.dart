import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/auth_provider.dart';
import 'package:suivi_budget/models/navigation/naviguer_inscription_page.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/views/widgets/custom_text_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';
import 'package:gap/gap.dart';

class ConnexionPage extends StatelessWidget {
  const ConnexionPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pwController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomLogoWidget(padding: 16.0, size: 50.0),
                  Gap(12),
                  headTextWidget(texte: "Connexion"),
                  descriptionText(
                    text: "Connectez-vous pour accéder à vos informations",
                    textalignment: TextAlign.center,
                  ),
                  Gap(20),
                  CustomTextfieldWidget(
                    label: "email",
                    typeInput: TextInputType.text,
                    controlleurChamp: emailController,
                    icone: Icons.mail,
                  ),
                  Gap(8),
                  CustomTextfieldWidget(
                    label: "Mot de passe",
                    typeInput: TextInputType.text,
                    controlleurChamp: pwController,
                    icone: Icons.password,
                  ),
                  Gap(20),
                  Consumer<AuthServicesProvider>(
                    builder: (context, auth, child) => CustomFilledButtonWidget(
                      texte: "Se connecter",
                      action: () => auth.singInUserWithEmail(
                        context: context,
                        email: emailController.text,
                        password: pwController.text,
                      ),
                      chargement: auth.chargement,
                    ),
                  ),
                  Gap(16),
                  CustomTextButtonWidget(
                    texte: "Créer un compte",
                    action: () => naviguerInscriptionPage(context),
                    chargement: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
