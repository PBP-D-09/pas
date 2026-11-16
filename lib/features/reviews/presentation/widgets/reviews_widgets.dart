import 'package:flutter/material.dart';

import '../../domain/entities/review.dart';
import '../../domain/entities/reviews_page_data.dart';

class ReviewsLoadingState extends StatelessWidget {
  const ReviewsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('Memuat reviews...'),
        ],
      ),
    );
  }
}

class ReviewsNoMenuState extends StatelessWidget {
  const ReviewsNoMenuState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rate_review_outlined, size: 48, color: colors.primary),
            const SizedBox(height: 16),
            Text(
              'Pilih menu terlebih dahulu',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'UUID menu diperlukan untuk memuat ulasan. Buka Reviews dari detail menu setelah Catalog meneruskan UUID-nya.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsErrorState extends StatelessWidget {
  const ReviewsErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 44, color: colors.error),
            const SizedBox(height: 12),
            Text(
              'Reviews tidak dapat dimuat',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsEmptyState extends StatelessWidget {
  const ReviewsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined, size: 40, color: colors.primary),
            const SizedBox(height: 12),
            Text(
              'Belum ada review',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Review untuk menu ini akan tampil di sini.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsMenuCard extends StatelessWidget {
  const ReviewsMenuCard({required this.menu, super.key});

  final ReviewMenu menu;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NetworkImageOrPlaceholder(
              imageUrl: menu.imageUrl,
              width: 76,
              height: 76,
              placeholderIcon: Icons.restaurant_menu,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (menu.tenant.isNotEmpty)
                    Text(
                      menu.tenant,
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  Text(
                    menu.name,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (menu.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      menu.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsSummaryCard extends StatelessWidget {
  const ReviewsSummaryCard({required this.summary, super.key});

  final ReviewRatingSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _formatAverage(summary.overallAverage),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RatingStars(rating: summary.overallAverage ?? 0),
                      const SizedBox(height: 4),
                      Text(
                        '${summary.total} review',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: colors.outlineVariant),
            const SizedBox(height: 14),
            _AverageRow(label: 'Food taste', average: summary.foodAverage),
            const SizedBox(height: 10),
            _AverageRow(
              label: 'Sustainable packaging',
              average: summary.packagingAverage,
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.review, super.key});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Text(review.author.initials),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.author.displayName,
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (review.createdAt != null)
                        Text(
                          _formatDate(review.createdAt!),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ReviewRatingRow(label: 'Food taste', rating: review.foodRating),
            const SizedBox(height: 8),
            _ReviewRatingRow(
              label: 'Sustainable packaging',
              rating: review.packagingRating,
            ),
            if (review.packagingTypeDisplay.isNotEmpty) ...[
              const SizedBox(height: 10),
              Chip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(
                  Icons.eco_outlined,
                  size: 16,
                  color: colors.tertiary,
                ),
                label: Text(review.packagingTypeDisplay),
                side: BorderSide.none,
                backgroundColor: colors.tertiaryContainer,
              ),
            ],
            const SizedBox(height: 8),
            Text(review.text, style: Theme.of(context).textTheme.bodyMedium),
            if (review.photoUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  review.photoUrl!,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _photoUnavailable(context),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 16,
                  color: colors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${review.helpfulCount} merasa review ini membantu',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AverageRow extends StatelessWidget {
  const _AverageRow({required this.label, required this.average});

  final String label;
  final double? average;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          '${_formatAverage(average)} / 5',
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(color: colors.primary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ReviewRatingRow extends StatelessWidget {
  const _ReviewRatingRow({required this.label, required this.rating});

  final String label;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        _RatingStars(rating: rating.toDouble()),
        const SizedBox(width: 6),
        Text('$rating.0', style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = rating >= index + 0.5;
        return Icon(
          isFilled ? Icons.star : Icons.star_border,
          size: 17,
          color: isFilled ? colors.tertiary : colors.outline,
        );
      }),
    );
  }
}

class _NetworkImageOrPlaceholder extends StatelessWidget {
  const _NetworkImageOrPlaceholder({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.placeholderIcon,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final url = imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null
            ? _placeholder(colors)
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(colors),
              ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colors) {
    return ColoredBox(
      color: colors.surfaceContainerHighest,
      child: Icon(placeholderIcon, color: colors.onSurfaceVariant),
    );
  }
}

Widget _photoUnavailable(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return Container(
    width: double.infinity,
    height: 160,
    color: colors.surfaceContainerHighest,
    alignment: Alignment.center,
    child: Icon(
      Icons.image_not_supported_outlined,
      color: colors.onSurfaceVariant,
    ),
  );
}

String _formatAverage(double? value) => value?.toStringAsFixed(1) ?? '–';

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
