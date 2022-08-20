part of 'splash_bloc.dart';

@immutable
abstract class SplashState {
  const SplashState();
}

class SplashInitialState extends SplashState {
  const SplashInitialState();
}

class SplashLoadedState extends SplashState {
  const SplashLoadedState();
}

class SplashFailureState extends SplashState {
  const SplashFailureState(this.error);

  final dynamic error;
}
