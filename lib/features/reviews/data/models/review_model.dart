import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.menuUuid,
    required super.author,
    required super.foodRating,
    required super.packagingRating,
    required super.packagingType,
    required super.packagingTypeDisplay,
    required super.text,
    required super.photoUrl,
    required super.sentiment,
    required super.helpfulCount,
    required super.hasVotedHelpful,
    required super.isMine,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, Object?> json) {
    final author = _asJsonMap(json['author'], 'author');
    return ReviewModel(
      id: _asInt(json['id'], 'id'),
      menuUuid: _asString(json['menu_uuid'], 'menu_uuid'),
      author: ReviewAuthor(
        id: _asInt(author['id'], 'author.id'),
        displayName: _asString(author['display_name'], 'author.display_name'),
        initials: _asString(author['initials'], 'author.initials'),
      ),
      foodRating: _asInt(json['food_rating'], 'food_rating'),
      packagingRating: _asInt(json['packaging_rating'], 'packaging_rating'),
      packagingType: _asString(json['packaging_type'], 'packaging_type'),
      packagingTypeDisplay: _asString(
        json['packaging_type_display'],
        'packaging_type_display',
      ),
      text: _asString(json['text'], 'text'),
      photoUrl: _asNullableString(json['photo_url'], 'photo_url'),
      sentiment: _asString(json['sentiment'], 'sentiment'),
      helpfulCount: _asInt(json['helpful_count'], 'helpful_count'),
      hasVotedHelpful: _asBool(json['has_voted_helpful'], 'has_voted_helpful'),
      isMine: _asBool(json['is_mine'], 'is_mine'),
      createdAt: _asNullableDateTime(json['created_at'], 'created_at'),
      updatedAt: _asNullableDateTime(json['updated_at'], 'updated_at'),
    );
  }
}

Map<String, Object?> _asJsonMap(Object? value, String field) {
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  throw FormatException('Expected an object for $field.');
}

String _asString(Object? value, String field) {
  if (value is String) return value;
  throw FormatException('Expected a string for $field.');
}

String? _asNullableString(Object? value, String field) {
  if (value == null) return null;
  return _asString(value, field);
}

int _asInt(Object? value, String field) {
  if (value is int) return value;
  throw FormatException('Expected an integer for $field.');
}

bool _asBool(Object? value, String field) {
  if (value is bool) return value;
  throw FormatException('Expected a boolean for $field.');
}

DateTime? _asNullableDateTime(Object? value, String field) {
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('Expected a date string for $field.');
  }
  return DateTime.tryParse(value);
}
