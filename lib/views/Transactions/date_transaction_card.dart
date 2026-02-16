import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:intl/intl.dart';

class DateTransactionCard extends StatefulWidget {
  final Function(DateTime) changementDate;
  const DateTransactionCard({super.key, required this.changementDate});

  @override
  State<DateTransactionCard> createState() => _DateTransactionCardState();
}

DateTime dateChoisie = DateTime.now();

class _DateTransactionCardState extends State<DateTransactionCard> {
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
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (value) {
                setState(() {
                  dateChoisie = value;
                });
                widget.changementDate(dateChoisie);
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
                Icon(Icons.date_range),
                Text(
                  "${DateFormat.yMMMMEEEEd().format(dateChoisie)} à ${DateFormat.Hm().format(dateChoisie)}",
                  style: Styles.texteTitre.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
