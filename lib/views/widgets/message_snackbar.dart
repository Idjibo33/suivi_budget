import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

/// Notification monochrome : le teal marque la réussite, le contraste marque
/// l'erreur. Aucune couleur de statut verte ou rouge n'est introduite.
class MessageSnackbar extends StatelessWidget {
  final String message;
  final bool erreur;

  const MessageSnackbar({
    super.key,
    required this.message,
    required this.erreur,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    final Color accent = erreur
        ? couleurs.onInverseSurface
        : couleurs.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: couleurs.inverseSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Row(
        children: [
          Icon(
            erreur ? Icons.error_outline : Icons.check_circle_outline,
            size: 18,
            color: accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Styles.texteCorps.copyWith(
                color: couleurs.onInverseSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
