import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_isar/app/navigator/go_navigation.dart';
import 'package:rick_and_morty_isar/app/state/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const AppRunner(),
    ),
  );
}

class AppRunner extends StatelessWidget {
  const AppRunner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, provider, child) {
      return MultiProvider(
        providers: [
          Provider(
            create: (context) => GoNavigation(appState: provider),
          ),
        ],
        child: const MyApp(),
      );
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = context.read<GoNavigation>();
    return MaterialApp.router(
      title: 'Rick And Morty',
      routeInformationProvider: navigation.router.routeInformationProvider,
      routeInformationParser: navigation.router.routeInformationParser,
      routerDelegate: navigation.router.routerDelegate,
    );
  }
}
