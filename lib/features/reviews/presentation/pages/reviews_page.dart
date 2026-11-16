import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/http_api_client.dart';
import '../../data/datasources/reviews_remote_data_source.dart';
import '../../data/repositories/reviews_repository_impl.dart';
import '../../domain/usecases/get_reviews.dart';
import '../providers/reviews_provider.dart';
import '../widgets/reviews_widgets.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key, this.menuUuid, this.provider});

  final String? menuUuid;
  final ReviewsProvider? provider;

  @override
  Widget build(BuildContext context) {
    final suppliedProvider = provider;
    if (suppliedProvider != null) {
      return ChangeNotifierProvider<ReviewsProvider>.value(
        value: suppliedProvider,
        child: _ReviewsPageBody(menuUuid: menuUuid),
      );
    }

    return ChangeNotifierProvider<ReviewsProvider>(
      create: (_) => _createProvider()..load(menuUuid),
      child: _ReviewsPageBody(menuUuid: menuUuid),
    );
  }

  ReviewsProvider _createProvider() {
    final remoteDataSource = ReviewsRemoteDataSource(
      apiClient: const HttpApiClient(),
    );
    final repository = ReviewsRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    return ReviewsProvider(getReviews: GetReviews(repository));
  }
}

class _ReviewsPageBody extends StatelessWidget {
  const _ReviewsPageBody({required this.menuUuid});

  final String? menuUuid;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewsProvider>(
      builder: (context, reviewsProvider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Reviews')),
          body: _buildBody(context, reviewsProvider),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReviewsProvider provider) {
    if (provider.needsMenuUuid) {
      return const ReviewsNoMenuState();
    }
    if (provider.isLoading) {
      return const ReviewsLoadingState();
    }
    if (provider.errorMessage != null) {
      return ReviewsErrorState(
        message: provider.errorMessage!,
        onRetry: () => provider.load(menuUuid),
      );
    }

    final data = provider.data;
    if (data == null) {
      return const ReviewsLoadingState();
    }

    return RefreshIndicator(
      onRefresh: () => provider.load(menuUuid),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          ReviewsMenuCard(menu: data.menu),
          const SizedBox(height: 24),
          Text(
            'Customer Reviews',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ReviewsSummaryCard(summary: data.summary),
          const SizedBox(height: 20),
          Text(
            'Review pelanggan (${data.pagination.count})',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (data.reviews.isEmpty)
            const ReviewsEmptyState()
          else
            for (final review in data.reviews) ...[
              ReviewCard(review: review),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}
