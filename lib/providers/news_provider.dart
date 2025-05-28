import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../services/news_service.dart';

// This provider manages the news articles state
// It handles fetching, loading states, and errors

// State class to hold news information
class NewsState {
  final List<Article> articles;
  final bool isLoading;
  final String? error;

  const NewsState({
    this.articles = const [],
    this.isLoading = false,
    this.error,
  });

  // Create a copy of the state with updated values
  NewsState copyWith({
    List<Article>? articles,
    bool? isLoading,
    String? error,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// The NewsNotifier manages news state changes
class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier() : super(const NewsState()) {
    // Load news when provider is created
    loadNews();
  }

  // Load top headlines
  Future<void> loadNews() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final articles = await NewsService.fetchTopHeadlines();
      state = state.copyWith(
        articles: articles,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load news: $e',
      );
    }
  }

  // Refresh news (for pull-to-refresh)
  Future<void> refreshNews() async {
    await loadNews();
  }

  // Search news articles
  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      // If search is empty, load all news
      await loadNews();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final articles = await NewsService.searchNews(query);
      state = state.copyWith(
        articles: articles,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to search news: $e',
      );
    }
  }
}

// Provider for news state
final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier();
}); 