import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/description_text_widget.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
            onTap: () {},
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Styles.couleurbgSecondaire,
              child: Icon(Icons.person, size: 40, color: Styles.couleurRevenu),
            ),
          ),
          headTextWidget(texte: "Nom prenom"),
          descriptionText(text: "email"),
          Gap(22),

          CustomFilledButtonWidget(
            texte: "Deconnecter",
            action: () {},
            chargement: false,
          ),
        ],
      ),
    );
  }
}
