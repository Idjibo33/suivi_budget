import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Local%20Auth/local_auth.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                final checking = await LocalAuth().checkLocalAuthAvailable();
                if (checking) {
                  debugPrint("true");
                } else {
                  debugPrint("false");
                }
              },
              child: Text('Check availability'),
            ),
            FilledButton(
              onPressed: () async {
                final x = await LocalAuth().getAvailableBiometrics();
                debugPrint(x.toString());
              },
              child: Text('Liste Biometrics'),
            ),
            FilledButton(
              onPressed: () async {
                final x = await LocalAuth().authenticated();
                debugPrint(x.toString());
              },
              child: Text('Authentifier'),
            ),
          ],
        ),
      ),
    );
  }
}
