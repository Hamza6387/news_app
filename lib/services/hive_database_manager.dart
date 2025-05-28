import 'package:hive_flutter/hive_flutter.dart';
import '../models/article.dart';
import '../models/user.dart';

// This class manages all Hive database operations using singleton pattern
// It centralizes database initialization, box management, and operations
class HiveDatabaseManager {
  // Singleton instance
  static HiveDatabaseManager? _instance;
  
  // Private constructor
  HiveDatabaseManager._();
  
  // Get singleton instance
  static HiveDatabaseManager get instance {
    _instance ??= HiveDatabaseManager._();
    return _instance!;
  }

  // Box names constants
  static const String _usersBoxName = 'users';
  static const String _bookmarksBoxName = 'bookmarks';
  static const String _settingsBoxName = 'settings';
  
  // Keys for storing data
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Private boxes
  Box<User>? _usersBox;
  Box<Article>? _bookmarksBox;
  Box? _settingsBox;

  // Initialize Hive database
  Future<void> initialize() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ArticleAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserAdapter());
      }
      
      // Open boxes
      _usersBox = await Hive.openBox<User>(_usersBoxName);
      _bookmarksBox = await Hive.openBox<Article>(_bookmarksBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
    } catch (e) {
      rethrow;
    }
  }

  // Get boxes with null checks
  Box<User> get usersBox {
    if (_usersBox == null || !_usersBox!.isOpen) {
      throw Exception('Users box is not initialized or closed');
    }
    return _usersBox!;
  }

  Box<Article> get bookmarksBox {
    if (_bookmarksBox == null || !_bookmarksBox!.isOpen) {
      throw Exception('Bookmarks box is not initialized or closed');
    }
    return _bookmarksBox!;
  }

  Box get settingsBox {
    if (_settingsBox == null || !_settingsBox!.isOpen) {
      throw Exception('Settings box is not initialized or closed');
    }
    return _settingsBox!;
  }

  // User Management Methods
  Future<void> saveUser(User user) async {
    await usersBox.put(_currentUserKey, user);
  }

  User? getCurrentUser() {
    return usersBox.get(_currentUserKey);
  }

  Future<void> removeCurrentUser() async {
    await usersBox.delete(_currentUserKey);
  }

  // Login Status Methods
  Future<void> setLoginStatus(bool isLoggedIn) async {
    await settingsBox.put(_isLoggedInKey, isLoggedIn);
  }

  bool getLoginStatus() {
    return settingsBox.get(_isLoggedInKey, defaultValue: false);
  }

  // Bookmark Methods
  Future<void> saveBookmark(Article article) async {
    await bookmarksBox.put(article.url, article);
  }

  Future<void> removeBookmark(String articleUrl) async {
    await bookmarksBox.delete(articleUrl);
  }

  List<Article> getAllBookmarks() {
    return bookmarksBox.values.toList();
  }

  bool isArticleBookmarked(String articleUrl) {
    return bookmarksBox.containsKey(articleUrl);
  }

  Future<void> clearAllBookmarks() async {
    await bookmarksBox.clear();
  }
} 