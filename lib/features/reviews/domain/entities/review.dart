class ReviewAuthor {
  const ReviewAuthor({
    required this.id,
    required this.displayName,
    required this.initials,
  });

  final int id;
  final String displayName;
  final String initials;
}

class Review {
  const Review({
    required this.id,
    required this.menuUuid,
    required this.author,
    required this.foodRating,
    required this.packagingRating,
    required this.packagingType,
    required this.packagingTypeDisplay,
    required this.text,
    required this.photoUrl,
    required this.sentiment,
    required this.helpfulCount,
    required this.hasVotedHelpful,
    required this.isMine,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String menuUuid;
  final ReviewAuthor author;
  final int foodRating;
  final int packagingRating;
  final String packagingType;
  final String packagingTypeDisplay;
  final String text;
  final String? photoUrl;
  final String sentiment;
  final int helpfulCount;
  final bool hasVotedHelpful;
  final bool isMine;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
