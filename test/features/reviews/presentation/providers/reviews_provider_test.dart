import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/features/reviews/data/models/reviews_page_model.dart';
import 'package:sustainabowl_mobile/features/reviews/domain/entities/reviews_page_data.dart';
import 'package:sustainabowl_mobile/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:sustainabowl_mobile/features/reviews/domain/usecases/get_reviews.dart';
import 'package:sustainabowl_mobile/features/reviews/presentation/providers/reviews_provider.dart';

import '../../fixtures/reviews_response.dart';

void main() {
  test('does not call the repository without a menu UUID', () async {
    final repository = _FakeReviewsRepository(
      result: ReviewsPageModel.fromJson(reviewsResponseJson),
    );
    final provider = ReviewsProvider(getReviews: GetReviews(repository));

    await provider.load(null);

    expect(provider.needsMenuUuid, isTrue);
    expect(provider.data, isNull);
    expect(repository.requestedMenuUuid, isNull);
  });

  test('loads review data and notifies listeners', () async {
    final repository = _FakeReviewsRepository(
      result: ReviewsPageModel.fromJson(reviewsResponseJson),
    );
    final provider = ReviewsProvider(getReviews: GetReviews(repository));
    var notifications = 0;
    provider.addListener(() => notifications++);

    await provider.load(' menu-uuid ');

    expect(repository.requestedMenuUuid, 'menu-uuid');
    expect(provider.data?.reviews.single.id, 42);
    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, isNull);
    expect(notifications, greaterThanOrEqualTo(2));
  });

  test('exposes a request error for the page to render', () async {
    final provider = ReviewsProvider(
      getReviews: GetReviews(
        _FakeReviewsRepository(error: StateError('connection failed')),
      ),
    );

    await provider.load('menu-uuid');

    expect(provider.isLoading, isFalse);
    expect(provider.errorMessage, contains('connection failed'));
    expect(provider.data, isNull);
  });
}

class _FakeReviewsRepository implements ReviewsRepository {
  _FakeReviewsRepository({this.result, this.error});

  final ReviewsPageData? result;
  final Object? error;
  String? requestedMenuUuid;

  @override
  Future<ReviewsPageData> getReviews(String menuUuid) async {
    requestedMenuUuid = menuUuid;
    if (error != null) throw error!;
    return result!;
  }
}
