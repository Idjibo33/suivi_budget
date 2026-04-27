import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Core/widgets/body_texte.dart';
import 'package:suivi_budget/Core/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/Core/widgets/custom_textfield_widget.dart';
import 'package:suivi_budget/Features/settings/logic/providers/user_prefs_provider.dart';

class EditUsernameBottomSheet extends StatefulWidget {
  const EditUsernameBottomSheet({super.key});

  @override
  State<EditUsernameBottomSheet> createState() =>
      _EditUsernameBottomSheetState();
}

class _EditUsernameBottomSheetState extends State<EditUsernameBottomSheet> {
  late TextEditingController textController;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              BodyTexte(texte: "Enregistrez une nouveau nom d'utilisateur"),
              const Gap(8),
              CustomTextfieldWidget(
                label: "Nom",
                typeInput: TextInputType.name,
                controlleurChamp: textController,
                icone: Icons.person,
              ),
              const Gap(12),
              Consumer<UserPrefsProvider>(
                builder: (context, value, child) => CustomFilledButtonWidget(
                  texte: "Enregistrer",
                  action: () async {
                    if (textController.text.isNotEmpty) {
                      value.saveUserInfos(newData: textController.text);
                      textController.clear();
                      Navigator.pop(context);
                    }
                  },
                  chargement: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
