import 'package:hive/hive.dart';

part 'article.g.dart';

// This class represents a single news article
// It contains all the information we need to display in our app
@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String title;           // Article headline
  @HiveField(1)
  final String description;     // Article summary
  @HiveField(2)
  final String url;            // Link to full article
  @HiveField(3)
  final String urlToImage;     // Link to article image
  @HiveField(4)
  final String publishedAt;    // When article was published
  @HiveField(5)
  final String sourceName;     // Name of news source
  @HiveField(6)
  final String content;        // Article content (may be truncated)

  // Constructor - this is how we create a new Article object
  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.sourceName,
    required this.content,
  });

  // Factory method to create Article from JSON (for API responses)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? json['text'] ?? 'No Description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? json['time']?.toString() ?? DateTime.now().toIso8601String(),
      sourceName: json['source']?['name'] ?? json['by'] ?? 'Unknown Source',
      content: json['content'] ?? json['text'] ?? '',
    );
  }

  // Factory method specifically for HackerNews API response
  factory Article.fromHackerNews(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['text'] ?? 'No description available',
      url: json['url'] ?? 'https://news.ycombinator.com/item?id=${json['id']}',
      urlToImage: '', // HackerNews doesn't provide images
      publishedAt: json['time'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000).toIso8601String()
          : DateTime.now().toIso8601String(),
      sourceName: 'Hacker News',
      content: json['text'] ?? '',
    );
  }

  // This helps us compare two articles to see if they're the same
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
} 