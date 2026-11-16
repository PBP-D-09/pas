import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/features/reviews/data/models/review_model.dart';
import 'package:sustainabowl_mobile/features/reviews/data/models/reviews_page_model.dart';

import '../../fixtures/reviews_response.dart';

void main() {
  group('ReviewModel.fromJson', () {
    test('parses the API review fields and nested author', () {
      final review = ReviewModel.fromJson(reviewJson());

      expect(review.id, 42);
      expect(review.menuUuid, '550e8400-e29b-41d4-a716-446655440000');
      expect(review.author.displayName, 'Ayu Pratama');
      expect(review.author.initials, 'AP');
      expect(review.foodRating, 4);
      expect(review.packagingRating, 5);
      expect(review.text, contains('fresh'));
      expect(review.photoUrl, 'https://example.test/reviews/photo.png');
      expect(review.helpfulCount, 3);
      expect(review.createdAt, DateTime.parse('2026-11-16T08:30:00Z'));
    });

    test('rejects fields that do not match the API types', () {
      expect(
        () => ReviewModel.fromJson({...reviewJson(), 'food_rating': '4'}),
        throwsFormatException,
      );
    });
  });

  test('parses the reviews list envelope and rating summary', () {
    final response = ReviewsPageModel.fromJson(reviewsResponseJson);

    expect(response.menu.name, 'Fresh Chicken & Greens Bowl');
    expect(response.summary.total, 1);
    expect(response.summary.foodAverage, 4.0);
    expect(response.summary.packagingAverage, 5.0);
    expect(response.pagination.pageSize, 4);
    expect(response.reviews, hasLength(1));
    expect(response.reviews.single, isA<ReviewModel>());
  });
}
