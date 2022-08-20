import 'dart:async';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rick_and_morty_isar/core/api/api_service.dart';
import 'package:rick_and_morty_isar/core/cache_manager/models/character_model.dart';
import 'package:rick_and_morty_isar/core/cache_manager/models/location_model.dart';

part 'helpers/stream_transforms.dart';
part 'services/character_services.dart';

abstract class CacheManager {
  Future<void> init();

  Stream<List<CharacterModel>> getCharacters();
}

class IsarCacheManager implements CacheManager {
  IsarCacheManager({required this.apiService});

  final ApiService apiService;

  Isar? _isar;

  @override
  Future<void> init() async {
    const dbName = '0.0.1_production';

    final directory = await getApplicationSupportDirectory();

    /// First we try to find an already open instance.
    _isar = Isar.getInstance(dbName);

    /// If an open instance could not be found, then open a new instance.
    _isar ??= await Isar.open(
      [
        CharacterModelSchema,
        LocationModelSchema,
      ],
      name: dbName,
      directory: directory.path,
    );
  }

  @override
  Stream<List<CharacterModel>> getCharacters() {
    late final StreamController<List<CharacterModel>> controller;

    /// This variable is needed to close the stream after we got the actual data.
    bool isNewData = false;

    controller = StreamController<List<CharacterModel>>(
      onListen: () async {
        /// First, we get the number of records to see if the data is already
        /// cached.
        final dbData = await _isar!.characterModels.count();

        /// If there is no data in the database, then by await we request the
        /// data to put it in the database, and then we save the data in the
        /// database, otherwise we request the data in the background, but
        /// immediately show the cache data from the db.
        if (dbData == 0) {
          isNewData = true;
          await _getCharactersData(dbConnection: _isar!);
        } else {
          _getCharactersData(dbConnection: _isar!);
        }

        _isar!.characterModels
            .where()
            .watch(initialReturn: true)
            .transform(_charactersTransform)
            .listen(
          (data) {
            controller.add(data);

            /// If it is new data, then close the stream, otherwise change the
            /// variable so that when get new data, we would close the stream.
            isNewData ? controller.close() : isNewData = true;
          },
          onError: (_) => controller.close(),
        );
      },
    );
    return controller.stream;
  }

  Future<void> _getCharactersData({required Isar dbConnection}) async {
    final serverData = await CharacterServices(apiService).getCharacters();

    await dbConnection.writeTxn(() async {
      for (final data in serverData) {
        if (data.location.value != null) {
          dbConnection.locationModels.put(data.location.value!);
        }
        if (data.origin.value != null) {
          dbConnection.locationModels.put(data.origin.value!);
        }
        dbConnection.characterModels.put(data);
      }
    });
  }
}
