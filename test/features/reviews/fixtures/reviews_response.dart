const reviewsResponseJson = <String, Object?>{
  'menu': {
    'uuid': '550e8400-e29b-41d4-a716-446655440000',
    'name': 'Fresh Chicken & Greens Bowl',
    'tenant': 'Salad & Veggie Bar',
    'description': 'Fresh greens, grilled chicken, and brown rice.',
    'image_url': null,
  },
  'summary': {
    'total': 1,
    'food_average': 4.0,
    'packaging_average': 5.0,
    'overall_average': 4.5,
    'distribution': [
      {'rating': 5, 'count': 0, 'percentage': 0.0},
      {'rating': 4, 'count': 1, 'percentage': 100.0},
      {'rating': 3, 'count': 0, 'percentage': 0.0},
      {'rating': 2, 'count': 0, 'percentage': 0.0},
      {'rating': 1, 'count': 0, 'percentage': 0.0},
    ],
  },
  'filters': {
    'rating': null,
    'sentiment': null,
    'packaging': null,
    'sort': null,
  },
  'pagination': {
    'count': 1,
    'page': 1,
    'page_size': 4,
    'total_pages': 1,
    'next': null,
    'previous': null,
  },
  'results': [
    {
      'id': 42,
      'menu_uuid': '550e8400-e29b-41d4-a716-446655440000',
      'author': {'id': 7, 'display_name': 'Ayu Pratama', 'initials': 'AP'},
      'food_rating': 4,
      'packaging_rating': 5,
      'packaging_type': 'reusable',
      'packaging_type_display': 'Reusable container',
      'text': 'The meal was fresh and the packaging stayed intact.',
      'photo_url': 'https://example.test/reviews/photo.png',
      'sentiment': 'positive',
      'helpful_count': 3,
      'has_voted_helpful': false,
      'is_mine': false,
      'created_at': '2026-11-16T08:30:00Z',
      'updated_at': '2026-11-16T08:30:00Z',
    },
  ],
};

Map<String, Object?> reviewJson() {
  final results = reviewsResponseJson['results']! as List<Object?>;
  return Map<String, Object?>.from(results.first! as Map);
}
