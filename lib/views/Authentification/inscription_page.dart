import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Supabase%20authentification%20services%20provider/auth_provider.dart';
import 'package:suivi_budget/models/navigation/naviguer_auth_gate.dart';
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
    TextEditingController confPwController = TextEditingController();

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
                  const CustomLogoWidget(padding: 16.0, size: 50),
                  const Gap(12),
                  headTextWidget(texte: 'Inscription'),
                  descriptionText(
                    text: "Créer un compte pour continuer",
                    textalignment: TextAlign.center,
                  ),
                  const Gap(20),
                  CustomTextfieldWidget(
                    label: "Nom",
                    typeInput: TextInputType.text,
                    controlleurChamp: nomController,
                    icone: Icons.person,
                  ),
                  const Gap(8),
                  CustomTextfieldWidget(
                    label: "prenom",
                    typeInput: TextInputType.text,
                    controlleurChamp: prenomController,
                    icone: Icons.person,
                  ),
                  const Gap(8),
                  CustomTextfieldWidget(
                    label: "email",
                    typeInput: TextInputType.text,
                    controlleurChamp: emailController,
                    icone: Icons.email,
                  ),
                  const Gap(8),
                  CustomTextfieldWidget(
                    label: "Mot de passe",
                    typeInput: TextInputType.text,
                    controlleurChamp: pwController,
                    icone: Icons.password,
                  ),
                  const Gap(8),
                  CustomTextfieldWidget(
                    label: "Confirmer le mot de passe",
                    typeInput: TextInputType.text,
                    controlleurChamp: confPwController,
                    icone: Icons.password,
                  ),
                  const Gap(20),
                  Consumer<AuthServicesProvider>(
                    builder: (context, auth, child) => CustomFilledButtonWidget(
                      texte: "Créer compte",
                      action: () async {
                        await auth.createUser(
                          context: context,
                          nom: nomController.text,
                          prenom: prenomController.text,
                          email: emailController.text,
                          password: pwController.text,
                          passwordConfirmation: confPwController.text,
                        );
                        if (context.mounted) naviguerAuthGate(context);
                      },
                      chargement: auth.chargement,
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
