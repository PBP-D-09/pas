import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';

class ReviewsRemoteDataSource {
  const ReviewsRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<Map<String, Object?>> getMenuReviews(String menuUuid) async {
    final path = '/api/v1/reviews/menus/${Uri.encodeComponent(menuUuid)}/';
    final response = await apiClient.get(path);
    if (response is Map) {
      return response.map((key, value) => MapEntry(key.toString(), value));
    }
    throw const AppFailure('Respons Reviews dari server tidak valid.');
  }
}
