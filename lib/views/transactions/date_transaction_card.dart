import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suivi_budget/constants.dart';

/// La date choisie appartient au formulaire parent : ce widget l'affiche
/// et notifie les changements sans dupliquer l'état.
class DateTransactionCard extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> changementDate;

  const DateTransactionCard({
    super.key,
    required this.date,
    required this.changementDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: CupertinoDatePicker(
              initialDateTime: date,
              onDateTimeChanged: changementDate,
              use24hFormat: true,
            ),
          );
        },
      ),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Styles.surfaceSecondaire(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 8,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd('fr_FR').format(date)} à ${DateFormat.Hm().format(date)}",
                    style: Styles.texteTitre.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
