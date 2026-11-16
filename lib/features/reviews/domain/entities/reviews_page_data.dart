import 'review.dart';

class ReviewMenu {
  const ReviewMenu({
    required this.uuid,
    required this.name,
    required this.tenant,
    required this.description,
    required this.imageUrl,
  });

  final String uuid;
  final String name;
  final String tenant;
  final String description;
  final String? imageUrl;
}

class RatingDistribution {
  const RatingDistribution({
    required this.rating,
    required this.count,
    required this.percentage,
  });

  final int rating;
  final int count;
  final double percentage;
}

class ReviewRatingSummary {
  const ReviewRatingSummary({
    required this.total,
    required this.foodAverage,
    required this.packagingAverage,
    required this.overallAverage,
    required this.distribution,
  });

  final int total;
  final double? foodAverage;
  final double? packagingAverage;
  final double? overallAverage;
  final List<RatingDistribution> distribution;
}

class ReviewPagination {
  const ReviewPagination({
    required this.count,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.next,
    required this.previous,
  });

  final int count;
  final int page;
  final int pageSize;
  final int totalPages;
  final int? next;
  final int? previous;
}

class ReviewsPageData {
  const ReviewsPageData({
    required this.menu,
    required this.summary,
    required this.pagination,
    required this.reviews,
  });

  final ReviewMenu menu;
  final ReviewRatingSummary summary;
  final ReviewPagination pagination;
  final List<Review> reviews;
}
