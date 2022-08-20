part of '../cache_manager.dart';

StreamTransformer<List<CharacterModel>, List<CharacterModel>>
    _charactersTransform =
    StreamTransformer.fromHandlers(handleData: (data, sink) async {
  for (final character in data) {
    await character.origin.load();
    await character.location.load();
  }

  sink.add(data);
});
