import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_isar/app/state/app_state.dart';
import 'package:rick_and_morty_isar/core/api/api_service.dart';
import 'package:rick_and_morty_isar/core/cache_manager/cache_manager.dart';
import 'package:rick_and_morty_isar/features/splash/domain/splash_interactor.dart';
import 'package:rick_and_morty_isar/features/splash/presentation/state/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(
        SplashInteractorImpl(
          context.read<AppState>(),
          context.read<ApiService>(),
          context.read<CacheManager>(),
        ),
      )..add(const SplashInitEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoadedState) {
            context.go('/');
          }
        },
        child: Scaffold(
          body: Center(
            child: BlocBuilder<SplashBloc, SplashState>(
                buildWhen: (_, current) => current is! SplashLoadedState,
                builder: (_, state) {
                  switch (state.runtimeType) {
                    case SplashInitialState:
                      return const CircularProgressIndicator();
                    case SplashFailureState:
                      return SizedBox(
                        width: 300,
                        child: Text(
                          (state as SplashFailureState).error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
