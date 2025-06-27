import 'package:fuzzy/fuzzy.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';

@injectable
class FuzzySearchUseCase {
  // Removed _fuzzy instance to create it dynamically in each method
  FuzzySearchUseCase();

  /// Creates a Fuzzy instance with the given categories and options
  Fuzzy<Category> _createFuzzy(List<Category> categories) {
    return Fuzzy<Category>(
      categories,
      options: FuzzyOptions(
        keys: [
          WeightedKey<Category>(
            name: 'name',
            getter: (category) => category.name,
            weight: 1.0,
          ),
        ],
        threshold: 0.3,
        distance: 100,
        location: 0,
        findAllMatches: true,
        minMatchCharLength: 1,
        shouldSort: true,
      ),
    );
  }

  /// Performs fuzzy search on categories
  List<Category> execute(List<Category> categories, String query) {
    if (query.isEmpty) {
      return categories;
    }

    // Create a new Fuzzy instance
    final fuzzy = _createFuzzy(categories);

    // Perform search
    final results = fuzzy.search(query);

    // Return matched categories, sorted by relevance
    return results.map((result) => result.item).toList();
  }

  /// Performs search with detailed match information
  List<FuzzySearchResult> executeWithDetails(
    List<Category> categories,
    String query,
  ) {
    if (query.isEmpty) {
      return categories
          .map(
            (category) =>
                FuzzySearchResult(category: category, score: 1.0, matches: []),
          )
          .toList();
    }

    // Create a new Fuzzy instance
    final fuzzy = _createFuzzy(categories);

    // Perform search
    final results = fuzzy.search(query);

    return results
        .map(
          (result) => FuzzySearchResult(
            category: result.item,
            score: result.score,
            matches:
                result.matches
                    .map(
                      (match) =>
                          SearchMatch(value: match.value, key: match.key),
                    )
                    .toList(),
          ),
        )
        .toList();
  }
}

class FuzzySearchResult {
  final Category category;
  final double score;
  final List<SearchMatch> matches;

  FuzzySearchResult({
    required this.category,
    required this.score,
    required this.matches,
  });
}

class SearchMatch {
  final String value;
  final String key;

  SearchMatch({required this.value, required this.key});
}
