import 'package:rick_and_morty_isar/app/state/app_state.dart';
import 'package:rick_and_morty_isar/core/api/api_service.dart';
import 'package:rick_and_morty_isar/core/cache_manager/cache_manager.dart';

abstract class SplashInteractor {
  Future<void> initApplication();
}

class SplashInteractorImpl implements SplashInteractor {
  SplashInteractorImpl(this._appState, this._apiService, this._cacheManager);

  final AppState _appState;
  final ApiService _apiService;
  final CacheManager _cacheManager;

  @override
  Future<void> initApplication() async {
    _apiService.init();
    await Future.delayed(const Duration(seconds: 2)); // For test
    await _cacheManager.init();
    _appState.setAppInit();
  }
}
