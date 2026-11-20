import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/features/reviews/data/models/reviews_page_model.dart';
import 'package:sustainabowl_mobile/features/reviews/domain/entities/reviews_page_data.dart';
import 'package:sustainabowl_mobile/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:sustainabowl_mobile/features/reviews/domain/usecases/get_reviews.dart';
import 'package:sustainabowl_mobile/features/reviews/presentation/pages/reviews_page.dart';
import 'package:sustainabowl_mobile/features/reviews/presentation/providers/reviews_provider.dart';

import '../../fixtures/reviews_response.dart';

void main() {
  testWidgets('shows menu selection instruction when UUID is missing', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ReviewsPage()));

    expect(find.text('Pilih menu terlebih dahulu'), findsOneWidget);
    expect(find.text('Reviews'), findsOneWidget);
  });

  testWidgets('shows loading while the request is pending', (tester) async {
    final completer = Completer<ReviewsPageData>();
    final provider = ReviewsProvider(
      getReviews: GetReviews(_FakeReviewsRepository(() => completer.future)),
    );
    final request = provider.load('menu-uuid');

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewsPage(menuUuid: 'menu-uuid', provider: provider),
      ),
    );
    expect(find.text('Memuat reviews...'), findsOneWidget);

    completer.complete(ReviewsPageModel.fromJson(reviewsResponseJson));
    await request;
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error and retry action when the request fails', (
    tester,
  ) async {
    final provider = ReviewsProvider(
      getReviews: GetReviews(
        _FakeReviewsRepository(
          () async => throw StateError('connection failed'),
        ),
      ),
    );
    await provider.load('menu-uuid');

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewsPage(menuUuid: 'menu-uuid', provider: provider),
      ),
    );

    expect(find.text('Reviews tidak dapat dimuat'), findsOneWidget);
    expect(find.textContaining('connection failed'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('shows an empty state for a successful empty response', (
    tester,
  ) async {
    final emptyJson = <String, Object?>{
      ...reviewsResponseJson,
      'summary': {
        'total': 0,
        'food_average': null,
        'packaging_average': null,
        'overall_average': null,
        'distribution': <Object?>[],
      },
      'pagination': {
        'count': 0,
        'page': 1,
        'page_size': 4,
        'total_pages': 1,
        'next': null,
        'previous': null,
      },
      'results': <Object?>[],
    };
    final provider = ReviewsProvider(
      getReviews: GetReviews(
        _FakeReviewsRepository(
          () async => ReviewsPageModel.fromJson(emptyJson),
        ),
      ),
    );
    await provider.load('menu-uuid');

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewsPage(menuUuid: 'menu-uuid', provider: provider),
      ),
    );

    expect(find.text('Belum ada review'), findsOneWidget);
  });

  testWidgets('renders reviewer, ratings, text, photo and helpful count', (
    tester,
  ) async {
    final provider = ReviewsProvider(
      getReviews: GetReviews(
        _FakeReviewsRepository(
          () async => ReviewsPageModel.fromJson(reviewsResponseJson),
        ),
      ),
    );
    await provider.load('menu-uuid');

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewsPage(menuUuid: 'menu-uuid', provider: provider),
      ),
    );
    await tester.pump();

    expect(find.text('Ayu Pratama'), findsOneWidget);
    expect(
      find.text('The meal was fresh and the packaging stayed intact.'),
      findsOneWidget,
    );
    expect(find.text('Food taste'), findsWidgets);
    expect(find.text('Sustainable packaging'), findsWidgets);
    expect(find.text('3 merasa review ini membantu'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}

class _FakeReviewsRepository implements ReviewsRepository {
  _FakeReviewsRepository(this.loadReviews);

  final Future<ReviewsPageData> Function() loadReviews;

  @override
  Future<ReviewsPageData> getReviews(String menuUuid) => loadReviews();
}
