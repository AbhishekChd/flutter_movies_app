// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      json['id'] as int,
      json['title'] as String,
      (json['vote_average'] as num).toDouble(),
      json['poster_path'] as String,
      (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
      json['overview'] as String,
      json['release_date'] as String,
      json['vote_count'] as int,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vote_average': instance.rating,
      'vote_count': instance.voteCount,
      'poster_path': instance.posterPath,
      'genre_ids': instance.genreIds,
      'overview': instance.overview,
      'release_date': instance.releaseDate,
    };
