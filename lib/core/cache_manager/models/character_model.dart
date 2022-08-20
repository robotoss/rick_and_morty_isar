import 'package:isar/isar.dart';
import 'package:rick_and_morty_isar/core/cache_manager/models/location_model.dart';

part 'character_model.g.dart';

@Collection()
class CharacterModel {
  Id? id;
  late String name;
  late String status;
  late String species;
  late String type;
  late String gender;
  final origin = IsarLink<LocationModel>();
  final location = IsarLink<LocationModel>();
  late String image;
  late List<String> episode;
  late String url;
  late DateTime created;
}
