import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';

// This screen shows the news feed with all articles
// It includes search functionality and pull-to-refresh
class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> {
  // Controller for search field
  final _searchController = TextEditingController();

  // Timer for search debouncing
  Timer? _searchTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  // Handle search input with debouncing
  void _onSearchChanged(String query) {
    // Cancel previous timer
    _searchTimer?.cancel();

    // Start new timer
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      // Search after 500ms delay
      final newsNotifier = ref.read(newsProvider.notifier);
      newsNotifier.searchNews(query);
    });
  }

  // Handle pull to refresh
  Future<void> _onRefresh() async {
    final newsNotifier = ref.read(newsProvider.notifier);
    await newsNotifier.refreshNews();
  }

  @override
  Widget build(BuildContext context) {
    // Watch news state
    final newsState = ref.watch(newsProvider);

    return Column(
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[50],
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search news...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        // News list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildNewsList(newsState),
          ),
        ),
      ],
    );
  }

  // Build the news list based on state
  Widget _buildNewsList(NewsState newsState) {
    if (newsState.isLoading && newsState.articles.isEmpty) {
      // Show loading indicator when first loading
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (newsState.error != null && newsState.articles.isEmpty) {
      // Show error message if no articles and there's an error
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load news',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              newsState.error!,
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newsNotifier = ref.read(newsProvider.notifier);
                newsNotifier.loadNews();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (newsState.articles.isEmpty) {
      // Show empty state
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No news found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Show articles list
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: newsState.articles.length,
      itemBuilder: (context, index) {
        final article = newsState.articles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ArticleCard(article: article),
        );
      },
    );
  }
}
