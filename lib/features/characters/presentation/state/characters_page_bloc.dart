import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_isar/core/cache_manager/cache_manager.dart';
import 'package:rick_and_morty_isar/core/cache_manager/models/character_model.dart';

part 'characters_page_event.dart';
part 'characters_page_state.dart';

class CharactersPageBloc
    extends Bloc<CharactersPageEvent, CharactersPageState> {
  CharactersPageBloc(this._cacheManager)
      : super(const CharactersPageInitialState()) {
    on<CharactersPageInitEvent>(_buildLoadDataHomeEvent);
    on<CharactersPageShowCharactersEvent>(
        _buildCharactersPageShowCharactersEvent);
    on<CharactersPageFailedEvent>((event, emit) => emit(
          CharactersPageInitFailureState(errorMessage: event.errorMessage),
        ));
  }

  final CacheManager _cacheManager;
  StreamSubscription? _dataStream;

  Future<void> _buildLoadDataHomeEvent(
    CharactersPageInitEvent event,
    Emitter<CharactersPageState> emit,
  ) async {
    emit(const CharactersPageInitialState());
    _dataStream = _cacheManager.getCharacters().listen(
      (characters) {
        add(CharactersPageShowCharactersEvent(characters: characters));
      },
      onError: (e) {
        String errorMessage = 'Unknown error';
        if (e is DioError) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        add(CharactersPageFailedEvent(errorMessage: errorMessage));
      },
      onDone: () => _dataStream?.cancel(),
    );
  }

  Future<void> _buildCharactersPageShowCharactersEvent(
    CharactersPageShowCharactersEvent event,
    Emitter<CharactersPageState> emit,
  ) async {
    emit(CharactersPageDataState(characters: event.characters));
  }
}
