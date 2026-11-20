import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/core/network/api_client.dart';
import 'package:sustainabowl_mobile/features/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:sustainabowl_mobile/features/reviews/data/models/reviews_page_model.dart';
import 'package:sustainabowl_mobile/features/reviews/data/repositories/reviews_repository_impl.dart';

import '../../fixtures/reviews_response.dart';

void main() {
  test('requests the menu endpoint and maps its JSON response', () async {
    final client = _FakeApiClient(reviewsResponseJson);
    final repository = ReviewsRepositoryImpl(
      remoteDataSource: ReviewsRemoteDataSource(apiClient: client),
    );

    final result = await repository.getReviews(
      '550e8400-e29b-41d4-a716-446655440000',
    );

    expect(
      client.requestedPath,
      '/api/v1/reviews/menus/550e8400-e29b-41d4-a716-446655440000/',
    );
    expect(result, isA<ReviewsPageModel>());
    expect(result.reviews.single.author.displayName, 'Ayu Pratama');
  });
}

class _FakeApiClient implements ApiClient {
  _FakeApiClient(this.response);

  final Object? response;
  String? requestedPath;

  @override
  Future<Object?> get(String path) async {
    requestedPath = path;
    return response;
  }

  @override
  Future<Object?> post(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  }) {
    throw UnimplementedError();
  }
}
