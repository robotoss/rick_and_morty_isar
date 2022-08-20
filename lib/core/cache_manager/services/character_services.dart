part of '../cache_manager.dart';

class CharacterServices {
  const CharacterServices(this._apiService);

  final ApiService _apiService;

  Future<List<CharacterModel>> getCharacters() async {
    final value = <CharacterModel>[];
    final characters = await _apiService.getAllCharacters();

    for (final character in characters) {
      final origin = LocationModel()
        ..name = character.origin.name
        ..url = character.origin.url;
      final location = LocationModel()
        ..name = character.location.name
        ..url = character.location.url;

      value.add(
        CharacterModel()
          ..id = character.id
          ..name = character.name
          ..status = character.status
          ..species = character.species
          ..type = character.type
          ..gender = character.gender
          ..origin.value = origin
          ..location.value = location
          ..image = character.image
          ..episode = character.episode
          ..url = character.url
          ..created = character.created,
      );
    }

    return value;
  }
}
