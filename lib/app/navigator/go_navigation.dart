import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_isar/app/state/app_state.dart';
import 'package:rick_and_morty_isar/features/home/presentation/home_page.dart';
import 'package:rick_and_morty_isar/features/splash/presentation/splash_page.dart';

class GoNavigation {
  GoNavigation({required this.appState});

  final AppState appState;

  late final router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
    ],
    redirect: (state) {
      final loadingSplash = state.location == '/splash';
      if (!appState.isInitialized) return loadingSplash ? null : '/splash';

      // no need to redirect at all
      return null;
    },
  );
}
