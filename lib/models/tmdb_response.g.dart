// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbResponse _$TmdbResponseFromJson(Map<String, dynamic> json) => TmdbResponse(
      json['page'] as int,
      json['total_results'] as int,
      json['total_pages'] as int,
      (json['results'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TmdbResponseToJson(TmdbResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
      'results': instance.movies?.map((e) => e.toJson()).toList(),
    };
