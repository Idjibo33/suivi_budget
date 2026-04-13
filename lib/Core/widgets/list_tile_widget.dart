import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/widgets/titre_texte.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback? action;
  final String texte;
  final IconData? icone;
  const ListTileWidget({
    super.key,
    this.action,
    required this.texte,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: ListTile(
        leading: Icon(icone),
        title: TitreTexte(texte: texte),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
