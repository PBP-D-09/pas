import '../entities/reviews_page_data.dart';
import '../repositories/reviews_repository.dart';

class GetReviews {
  const GetReviews(this.repository);

  final ReviewsRepository repository;

  Future<ReviewsPageData> call(String menuUuid) {
    return repository.getReviews(menuUuid);
  }
}
