import '../../domain/entities/reviews_page_data.dart';
import 'review_model.dart';

class ReviewsPageModel extends ReviewsPageData {
  const ReviewsPageModel({
    required super.menu,
    required super.summary,
    required super.pagination,
    required super.reviews,
  });

  factory ReviewsPageModel.fromJson(Map<String, Object?> json) {
    final menu = _asJsonMap(json['menu'], 'menu');
    final summary = _asJsonMap(json['summary'], 'summary');
    final pagination = _asJsonMap(json['pagination'], 'pagination');
    final rawResults = json['results'];
    if (rawResults is! List) {
      throw const FormatException('Expected a list for results.');
    }

    final rawDistribution = summary['distribution'];
    if (rawDistribution is! List) {
      throw const FormatException('Expected a list for summary.distribution.');
    }

    return ReviewsPageModel(
      menu: ReviewMenu(
        uuid: _asString(menu['uuid'], 'menu.uuid'),
        name: _asString(menu['name'], 'menu.name'),
        tenant: _asString(menu['tenant'], 'menu.tenant'),
        description: _asString(menu['description'], 'menu.description'),
        imageUrl: _asNullableString(menu['image_url'], 'menu.image_url'),
      ),
      summary: ReviewRatingSummary(
        total: _asInt(summary['total'], 'summary.total'),
        foodAverage: _asNullableDouble(
          summary['food_average'],
          'summary.food_average',
        ),
        packagingAverage: _asNullableDouble(
          summary['packaging_average'],
          'summary.packaging_average',
        ),
        overallAverage: _asNullableDouble(
          summary['overall_average'],
          'summary.overall_average',
        ),
        distribution: rawDistribution
            .map(
              (item) => _ratingDistribution(
                _asJsonMap(item, 'summary.distribution[]'),
              ),
            )
            .toList(growable: false),
      ),
      pagination: ReviewPagination(
        count: _asInt(pagination['count'], 'pagination.count'),
        page: _asInt(pagination['page'], 'pagination.page'),
        pageSize: _asInt(pagination['page_size'], 'pagination.page_size'),
        totalPages: _asInt(pagination['total_pages'], 'pagination.total_pages'),
        next: _asNullableInt(pagination['next'], 'pagination.next'),
        previous: _asNullableInt(pagination['previous'], 'pagination.previous'),
      ),
      reviews: rawResults
          .map((item) => ReviewModel.fromJson(_asJsonMap(item, 'results[]')))
          .toList(growable: false),
    );
  }
}

RatingDistribution _ratingDistribution(Map<String, Object?> json) {
  return RatingDistribution(
    rating: _asInt(json['rating'], 'summary.distribution.rating'),
    count: _asInt(json['count'], 'summary.distribution.count'),
    percentage: _asDouble(
      json['percentage'],
      'summary.distribution.percentage',
    ),
  );
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

int? _asNullableInt(Object? value, String field) {
  if (value == null) return null;
  return _asInt(value, field);
}

double _asDouble(Object? value, String field) {
  if (value is num) return value.toDouble();
  throw FormatException('Expected a number for $field.');
}

double? _asNullableDouble(Object? value, String field) {
  if (value == null) return null;
  return _asDouble(value, field);
}
