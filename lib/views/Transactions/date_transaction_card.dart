import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suivi_budget/constants.dart';

class DateTransactionCard extends StatefulWidget {
  final Function(DateTime) changementDate;
  const DateTransactionCard({super.key, required this.changementDate});

  @override
  State<DateTransactionCard> createState() => _DateTransactionCardState();
}

class _DateTransactionCardState extends State<DateTransactionCard> {
  DateTime _dateChoisie = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: CupertinoDatePicker(
              initialDateTime: _dateChoisie,
              onDateTimeChanged: (value) {
                setState(() {
                  _dateChoisie = value;
                });
                widget.changementDate(_dateChoisie);
              },
              use24hFormat: true,
            ),
          );
        },
      ),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Styles.couleurbgSecondaire,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 8,
              children: [
                const Icon(Icons.date_range),
                Expanded(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd('fr_FR').format(_dateChoisie)} à ${DateFormat.Hm().format(_dateChoisie)}",
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
