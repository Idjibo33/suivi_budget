import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/widgets/titre_texte.dart';
import 'package:suivi_budget/Features/chart/presentation/widgets/chart_widget.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitreTexte(texte: "Transactions"),
              SizedBox(
                height: MediaQuery.of(context).size.width / 1,
                child: ChartWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
