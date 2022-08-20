import 'dart:convert';

import 'package:dio/dio.dart';

part 'models/character.dart';

abstract class ApiService {
  void init();

  Future<List<CharacterModel>> getAllCharacters();
}

class DioAppService implements ApiService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api/',
      connectTimeout: 4000,
      receiveTimeout: 4000,
      sendTimeout: 4000,
    ),
  );

  @override
  void init() {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }

  @override
  Future<List<CharacterModel>> getAllCharacters() async {
    int page = 1;
    final characters = <CharacterModel>[];

    Future.doWhile(() async {
      final response = await _dio.get('?page=$page');
      final responseChars = characterModelFromJson(response.data).results;
      characters.addAll(responseChars);
      page++;
      return page == 30;
    });

    return characters;
  }
}
