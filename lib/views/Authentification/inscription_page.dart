import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Functions/inscrire_utilisateur.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/inscription_service_provider.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';
import 'package:gap/gap.dart';

class InscriptionPage extends StatelessWidget {
  const InscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nomController = TextEditingController();
    TextEditingController prenomController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController pwController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomLogoWidget(),
                  Gap(12),
                  headTextWidget(texte: 'Inscription'),
                  descriptionText(
                    text: "Créer un compte pour continuer",
                    textalignment: TextAlign.center,
                  ),
                  Gap(20),
                  CustomTextfieldWidget(
                    label: "Nom",
                    typeInput: TextInputType.text,
                    controlleurChamp: nomController,
                    icone: Icons.person,
                  ),
                  Gap(8),
                  CustomTextfieldWidget(
                    label: "prenom",
                    typeInput: TextInputType.text,
                    controlleurChamp: prenomController,
                    icone: Icons.person,
                  ),
                  Gap(8),
                  CustomTextfieldWidget(
                    label: "email",
                    typeInput: TextInputType.text,
                    controlleurChamp: emailController,
                    icone: Icons.email,
                  ),
                  Gap(8),
                  CustomTextfieldWidget(
                    label: "Mot de passe",
                    typeInput: TextInputType.text,
                    controlleurChamp: pwController,
                    icone: Icons.password,
                  ),
                  Gap(20),
                  Consumer<InscriptionServiceProvider>(
                    builder: (context, value, child) =>
                        CustomFilledButtonWidget(
                          texte: "Créer compte",
                          action: () => inscrireUtilisateur(
                            context: context,
                            nom: nomController.text,
                            prenom: prenomController.text,
                            email: emailController.text,
                            pw: pwController.text,
                          ),
                          chargement: value.chargement,
                        ),
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
