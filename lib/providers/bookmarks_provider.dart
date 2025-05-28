import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../services/hive_database_manager.dart';

// This provider manages the bookmarked articles state
// It handles saving, removing, and loading bookmarks

// State class to hold bookmarks information
class BookmarksState {
  final List<Article> bookmarks;
  final bool isLoading;
  final String? error;

  const BookmarksState({
    this.bookmarks = const [],
    this.isLoading = false,
    this.error,
  });

  // Create a copy of the state with updated values
  BookmarksState copyWith({
    List<Article>? bookmarks,
    bool? isLoading,
    String? error,
  }) {
    return BookmarksState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// The BookmarksNotifier manages bookmarks state changes
class BookmarksNotifier extends StateNotifier<BookmarksState> {
  final HiveDatabaseManager _databaseManager = HiveDatabaseManager.instance;

  BookmarksNotifier() : super(const BookmarksState()) {
    // Load bookmarks when provider is created
    loadBookmarks();
  }

  // Load all bookmarks from storage
  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final bookmarks = _databaseManager.getAllBookmarks();
      state = state.copyWith(
        bookmarks: bookmarks,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load bookmarks: $e',
      );
    }
  }

  // Add article to bookmarks
  Future<void> addBookmark(Article article) async {
    try {
      await _databaseManager.saveBookmark(article);

      // Update state by adding the article if it's not already there
      final currentBookmarks = List<Article>.from(state.bookmarks);
      if (!currentBookmarks.any((bookmark) => bookmark.url == article.url)) {
        currentBookmarks.add(article);
        state = state.copyWith(bookmarks: currentBookmarks);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to add bookmark: $e');
    }
  }

  // Remove article from bookmarks
  Future<void> removeBookmark(Article article) async {
    try {
      await _databaseManager.removeBookmark(article.url);

      // Update state by removing the article
      final currentBookmarks = List<Article>.from(state.bookmarks);
      currentBookmarks.removeWhere((bookmark) => bookmark.url == article.url);
      state = state.copyWith(bookmarks: currentBookmarks);
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove bookmark: $e');
    }
  }

  // Toggle bookmark status
  Future<void> toggleBookmark(Article article) async {
    final isBookmarked = _databaseManager.isArticleBookmarked(article.url);

    if (isBookmarked) {
      await removeBookmark(article);
    } else {
      await addBookmark(article);
    }
  }

  // Check if article is bookmarked
  bool isBookmarked(Article article) {
    return _databaseManager.isArticleBookmarked(article.url);
  }

  // Clear all bookmarks
  Future<void> clearAllBookmarks() async {
    try {
      await _databaseManager.clearAllBookmarks();
      state = state.copyWith(bookmarks: []);
    } catch (e) {
      state = state.copyWith(error: 'Failed to clear bookmarks: $e');
    }
  }
}

// Provider for bookmarks state
final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, BookmarksState>((ref) {
  return BookmarksNotifier();
});
