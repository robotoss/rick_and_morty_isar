import 'package:rick_and_morty_isar/app/state/app_state.dart';

abstract class SplashInteractor {
  Future<void> initApplication();
}

class SplashInteractorImpl implements SplashInteractor {
  SplashInteractorImpl(this._appState);
  final AppState _appState;

  @override
  Future<void> initApplication() async {
    await Future.delayed(const Duration(seconds: 3));
    _appState.setAppInit();
  }
}
