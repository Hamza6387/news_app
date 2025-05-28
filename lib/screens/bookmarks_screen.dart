import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/article_card.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksState = ref.watch(bookmarksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
        await bookmarksNotifier.loadBookmarks();
      },
      child: _buildBookmarksList(context, ref, bookmarksState),
    );
  }

  // Build the bookmarks list based on state
  Widget _buildBookmarksList(
    BuildContext context,
    WidgetRef ref,
    BookmarksState bookmarksState,
  ) {
    if (bookmarksState.isLoading && bookmarksState.bookmarks.isEmpty) {
      // Show loading indicator when first loading
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (bookmarksState.error != null && bookmarksState.bookmarks.isEmpty) {
      // Show error message if no bookmarks and there's an error
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
              'Failed to load bookmarks',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bookmarksState.error!,
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
                bookmarksNotifier.loadBookmarks();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (bookmarksState.bookmarks.isEmpty) {
      // Show empty state when no bookmarks
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarks yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bookmark articles from the news feed to see them here',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show bookmarks list with clear all option
    return Column(
      children: [
        // Header with clear all button
        if (bookmarksState.bookmarks.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${bookmarksState.bookmarks.length} bookmarked articles',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showClearAllDialog(context, ref),
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),

        // Bookmarks list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarksState.bookmarks.length,
            itemBuilder: (context, index) {
              final article = bookmarksState.bookmarks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ArticleCard(
                  article: article,
                  showRemoveOption: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Show confirmation dialog for clearing all bookmarks
  Future<void> _showClearAllDialog(BuildContext context, WidgetRef ref) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Bookmarks'),
        content: const Text(
          'Are you sure you want to remove all bookmarked articles? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
      await bookmarksNotifier.clearAllBookmarks();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All bookmarks cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
