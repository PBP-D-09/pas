import '../../domain/entities/reviews_page_data.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../datasources/reviews_remote_data_source.dart';
import '../models/reviews_page_model.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  const ReviewsRepositoryImpl({required this.remoteDataSource});

  final ReviewsRemoteDataSource remoteDataSource;

  @override
  Future<ReviewsPageData> getReviews(String menuUuid) async {
    final json = await remoteDataSource.getMenuReviews(menuUuid);
    return ReviewsPageModel.fromJson(json);
  }
}
