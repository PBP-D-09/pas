import '../entities/reviews_page_data.dart';

abstract interface class ReviewsRepository {
  Future<ReviewsPageData> getReviews(String menuUuid);
}
