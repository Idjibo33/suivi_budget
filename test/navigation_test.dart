import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/auth_provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';

import 'fixtures/fakes.dart';

class _RouteObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushed = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}

Future<void> pumpNavigation(
  WidgetTester tester,
  FakeTransactionDao dao,
  NavigatorObserver observer,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ModifierTransactionViewProvider()),
      ],
      child: MaterialApp(
        navigatorObservers: [observer],
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => naviguerAjouterTransactionPage(context),
                child: const Text('ouvrir'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  late FakeTransactionDao dao;
  late _RouteObserver observer;

  setUp(() {
    dao = FakeTransactionDao();
    observer = _RouteObserver();
  });

  tearDown(() => dao.close());

  testWidgets('sur iOS : une seule route Cupertino', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await pumpNavigation(tester, dao, observer);
    observer.pushed.clear();

    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();

    expect(observer.pushed, hasLength(1));
    expect(observer.pushed.single, isA<CupertinoPageRoute<void>>());
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('sur Android : une seule route Material', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await pumpNavigation(tester, dao, observer);
    observer.pushed.clear();

    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();

    expect(observer.pushed, hasLength(1));
    expect(observer.pushed.single, isA<MaterialPageRoute<void>>());
    debugDefaultTargetPlatformOverride = null;
  });
}
