import 'package:demo_frs_app/models/product.dart';

class SearchResults {
  final String searchTerm;
  final List<Product> searchResults;

  SearchResults({
    required this.searchTerm,
    required this.searchResults,
  });
}
