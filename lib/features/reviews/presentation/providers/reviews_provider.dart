import 'package:flutter/foundation.dart';

import '../../domain/entities/reviews_page_data.dart';
import '../../domain/usecases/get_reviews.dart';

class ReviewsProvider extends ChangeNotifier {
  ReviewsProvider({required this.getReviews});

  final GetReviews getReviews;

  ReviewsPageData? _data;
  String? _errorMessage;
  bool _isLoading = false;
  bool _needsMenuUuid = false;

  ReviewsPageData? get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get needsMenuUuid => _needsMenuUuid;

  Future<void> load(String? menuUuid) async {
    final normalizedUuid = menuUuid?.trim();
    if (normalizedUuid == null || normalizedUuid.isEmpty) {
      _data = null;
      _errorMessage = null;
      _isLoading = false;
      _needsMenuUuid = true;
      notifyListeners();
      return;
    }

    _needsMenuUuid = false;
    _isLoading = true;
    _errorMessage = null;
    _data = null;
    notifyListeners();

    try {
      _data = await getReviews(normalizedUuid);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
