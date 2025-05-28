import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../providers/bookmarks_provider.dart';
import '../screens/article_detail_screen.dart';
import '../utils/date_formatter.dart';

// This widget displays an article in a card format
// It shows the thumbnail, title, description, source, and date
// Users can tap to read the full article or bookmark it
class ArticleCard extends ConsumerWidget {
  final Article article;
  final bool showRemoveOption;

  const ArticleCard({
    super.key,
    required this.article,
    this.showRemoveOption = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch bookmarks state to update bookmark icon
    final bookmarksNotifier = ref.watch(bookmarksProvider.notifier);
    final isBookmarked = bookmarksNotifier.isBookmarked(article);

    return Card(
      child: InkWell(
        onTap: () => _openArticleDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article image
            _buildArticleImage(),

            // Article content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Source and date row
                  Row(
                    children: [
                      // Source
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.source,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                article.sourceName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Date
                      Text(
                        DateFormatter.formatPublishedDate(article.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Read more button
                      TextButton.icon(
                        onPressed: () => _openArticleDetail(context),
                        icon: const Icon(Icons.read_more, size: 16),
                        label: const Text('Read More'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),

                      // Bookmark button
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showRemoveOption)
                            TextButton.icon(
                              onPressed: () => _removeBookmark(context, ref),
                              icon: const Icon(Icons.delete, size: 16),
                              label: const Text('Remove'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            )
                          else
                            IconButton(
                              onPressed: () => _toggleBookmark(context, ref),
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color:
                                    isBookmarked ? Colors.amber : Colors.grey,
                              ),
                              tooltip: isBookmarked
                                  ? 'Remove bookmark'
                                  : 'Add bookmark',
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build article image with placeholder
  Widget _buildArticleImage() {
    if (article.urlToImage.isEmpty) {
      // Show placeholder if no image
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: 48,
            color: Colors.grey[400],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.network(
        article.urlToImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
          );
        },
      ),
    );
  }

  // Open article detail screen
  void _openArticleDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  // Toggle bookmark status
  Future<void> _toggleBookmark(BuildContext context, WidgetRef ref) async {
    final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
    await bookmarksNotifier.toggleBookmark(article);

    // Show feedback to user
    final isBookmarked = bookmarksNotifier.isBookmarked(article);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isBookmarked ? 'Article bookmarked!' : 'Bookmark removed!',
          ),
          backgroundColor: isBookmarked ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Remove bookmark with confirmation
  Future<void> _removeBookmark(BuildContext context, WidgetRef ref) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: const Text('Are you sure you want to remove this bookmark?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      final bookmarksNotifier = ref.read(bookmarksProvider.notifier);
      await bookmarksNotifier.removeBookmark(article);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bookmark removed!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
