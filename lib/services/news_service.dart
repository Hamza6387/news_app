import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/article.dart';

// This service handles news API calls from NewsAPI.org only
class NewsService {
  // NewsAPI.org configuration for Indian news
  static const String _newsApiKey = 'bbe8bd0a3f1140b2970ed790acf95d7b';
  static const String _newsApiBaseUrl = 'https://newsapi.org/v2';

  // Fetch top headlines from India
  static Future<List<Article>> fetchTopHeadlines() async {
    try {
      // Using US instead of IN because India returns no articles currently
      final url =
          '$_newsApiBaseUrl/top-headlines?country=us&apiKey=$_newsApiKey';

      if (kDebugMode) {
        debugPrint('🌐 Fetching news from: $url');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check for API errors
        if (data['status'] != 'ok') {
          throw Exception(
              'NewsAPI Error: ${data['message'] ?? 'Unknown error'}');
        }

        final List<dynamic> articlesJson = data['articles'] ?? [];

        if (articlesJson.isEmpty) {
          if (kDebugMode) {
            debugPrint('⚠️ No articles found from NewsAPI');
          }
          return _getMockArticles();
        }

        final articles = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) =>
                article.title != '[Removed]' &&
                article.url.isNotEmpty &&
                article.title.isNotEmpty)
            .take(20)
            .toList();

        if (kDebugMode) {
          debugPrint(
              '✅ Successfully fetched ${articles.length} articles from NewsAPI');
        }

        return articles;
      } else if (response.statusCode == 401) {
        if (kDebugMode) {
          debugPrint('❌ Invalid NewsAPI key');
        }
        return _getMockArticles();
      } else if (response.statusCode == 429) {
        if (kDebugMode) {
          debugPrint('❌ NewsAPI rate limit exceeded');
        }
        return _getMockArticles();
      } else {
        if (kDebugMode) {
          debugPrint('❌ NewsAPI request failed: ${response.statusCode}');
        }
        return _getMockArticles();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching news: $e');
      }
      return _getMockArticles();
    }
  }

  // Search for news articles in India
  static Future<List<Article>> searchNews(String query) async {
    if (query.trim().isEmpty) {
      return await fetchTopHeadlines();
    }

    try {
      final url =
          '$_newsApiBaseUrl/everything?q=${Uri.encodeComponent(query)}&apiKey=$_newsApiKey&language=en&sortBy=publishedAt';

      if (kDebugMode) {
        debugPrint('🔍 Searching NewsAPI for: "$query"');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] != 'ok') {
          throw Exception(
              'NewsAPI Search Error: ${data['message'] ?? 'Unknown error'}');
        }

        final List<dynamic> articlesJson = data['articles'] ?? [];

        if (articlesJson.isEmpty) {
          if (kDebugMode) {
            debugPrint('🔍 No search results found, using local search');
          }
          // Fallback to local search in headlines
          final allArticles = await fetchTopHeadlines();
          return allArticles
              .where((article) =>
                  article.title.toLowerCase().contains(query.toLowerCase()) ||
                  article.description
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  article.sourceName
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();
        }

        final articles = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) =>
                article.title != '[Removed]' &&
                article.url.isNotEmpty &&
                article.title.isNotEmpty)
            .take(30)
            .toList();

        if (kDebugMode) {
          debugPrint('🔍 Found ${articles.length} articles for "$query"');
        }

        return articles;
      } else {
        if (kDebugMode) {
          debugPrint('❌ Search failed: ${response.statusCode}');
        }
        // Fallback to local search in headlines
        final allArticles = await fetchTopHeadlines();
        return allArticles
            .where((article) =>
                article.title.toLowerCase().contains(query.toLowerCase()) ||
                article.description
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                article.sourceName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Search error: $e');
      }
      // Fallback to local search
      try {
        final allArticles = await fetchTopHeadlines();
        return allArticles
            .where((article) =>
                article.title.toLowerCase().contains(query.toLowerCase()) ||
                article.description
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                article.sourceName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } catch (e) {
        return [];
      }
    }
  }

  // Mock data as fallback when API fails
  static List<Article> _getMockArticles() {
    return [
      Article(
        title: 'OpenAI Launches ChatGPT-5 with Revolutionary AI Capabilities',
        description:
            'OpenAI unveils its most advanced language model yet, featuring enhanced reasoning, creativity, and problem-solving abilities.',
        url: 'https://www.reuters.com/technology/artificial-intelligence/',
        urlToImage: 'https://picsum.photos/400/200?random=1',
        publishedAt:
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        sourceName: 'Reuters',
        content:
            'OpenAI continues to push the boundaries of artificial intelligence with significant new developments...',
      ),
      Article(
        title: 'Stock Markets Hit Record Highs Amid Tech Rally',
        description:
            'Major stock indices reach all-time highs as technology companies lead the market surge.',
        url: 'https://www.bloomberg.com/markets',
        urlToImage: 'https://picsum.photos/400/200?random=2',
        publishedAt:
            DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
        sourceName: 'Bloomberg',
        content:
            'Financial markets demonstrate strong performance with technology sector leading the charge...',
      ),
      Article(
        title: 'Climate Summit Reaches Historic Agreement on Renewable Energy',
        description:
            'World leaders commit to ambitious new targets for clean energy transition and carbon reduction.',
        url: 'https://www.bbc.com/news',
        urlToImage: 'https://picsum.photos/400/200?random=3',
        publishedAt:
            DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        sourceName: 'BBC News',
        content:
            'International cooperation on climate change reaches new milestones with comprehensive agreements...',
      ),
    ];
  }
}
