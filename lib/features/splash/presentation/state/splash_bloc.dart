import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_isar/features/splash/domain/splash_interactor.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._interactor) : super(SplashInitialState()) {
    on<SplashInitEvent>(_splashInitEvent);
  }

  final SplashInteractor _interactor;

  Future<void> _splashInitEvent(event, emit) async {
    await _interactor.initApplication();
    emit(SplashLoadedState());
  }
}
