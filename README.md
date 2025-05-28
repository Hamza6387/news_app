# News Buzz - Flutter News App

A beautiful and modern Flutter news application with login and bookmark features. This app demonstrates clean architecture principles, state management with Riverpod, and robust local storage using Hive database.

## 📱 Features

### ✅ Core Features (As Required)

#### 1. Login Page
- ✅ Email and password fields
- ✅ Login button
- ✅ Simple validation (required fields, email format)
- ✅ No backend connection (local validation)
- ✅ Save login session with Hive database (users don't need to log in every time)

#### 2. News Feed Page
- ✅ Get news from real news APIs (NewsAPI.org + HackerNews API)
- ✅ Show each article with:
  - 1. Thumbnail image
  - 2. Title
  - 3. Description
  - 4. Source name
  - 5. Published Date in format [16 April, 2025]
- ✅ Tap on article shows full content in WebView
- ✅ Add bookmark button to save articles using Hive database

#### 3. Bookmarks Page
- ✅ Show all saved articles from Hive database
- ✅ Option to remove articles from bookmarks
- ✅ Bookmarks persist when app is closed (stored in Hive)

#### 4. Navigation
- ✅ Tab bar to switch between news and bookmark pages

### 🎯 Optional Extras Implemented
- ✅ Pull-to-refresh functionality
- ✅ Search functionality with debouncing
- ✅ Beautiful and modern UI design
- ✅ Loading states and error handling
- ✅ Confirmation dialogs for destructive actions
- ✅ Responsive design
- ✅ High-performance NoSQL local storage with Hive

## 🏗️ Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── main.dart                 # App entry point with Hive initialization
├── models/                   # Data models with Hive annotations
│   ├── article.dart         # Article model with Hive TypeAdapter
│   ├── article.g.dart       # Generated Hive adapter for Article
│   ├── user.dart            # User model with Hive TypeAdapter
│   └── user.g.dart          # Generated Hive adapter for User
├── services/                # Business logic layer
│   ├── hive_database_manager.dart # Singleton Hive database manager
│   └── news_service.dart    # Real news API service (NewsAPI + HackerNews)
├── providers/               # State management (Riverpod)
│   ├── auth_provider.dart   # Authentication state
│   ├── news_provider.dart   # News articles state
│   └── bookmarks_provider.dart # Bookmarks state
├── screens/                 # UI screens
│   ├── splash_screen.dart   # Initial loading screen
│   ├── login_screen.dart    # User authentication
│   ├── home_screen.dart     # Main app with tab navigation
│   ├── news_feed_screen.dart # News articles list
│   ├── bookmarks_screen.dart # Saved articles
│   └── article_detail_screen.dart # WebView for full articles
├── widgets/                 # Reusable UI components
│   └── article_card.dart    # Article display card
└── utils/                   # Helper functions
    ├── date_formatter.dart  # Date formatting utilities
    └── validators.dart      # Form validation functions
```

### 🎨 Design Patterns Used

1. **Repository Pattern**: For data access abstraction
2. **Singleton Pattern**: HiveDatabaseManager for centralized database management
3. **Provider Pattern**: Using Riverpod for state management
4. **Factory Pattern**: For model creation from JSON
5. **Observer Pattern**: Through Riverpod's reactive state management

## 📦 Third-Party Packages Used

| Package | Version | Purpose | Why Used |
|---------|---------|---------|----------|
| `flutter_riverpod` | ^2.4.9 | State Management | Reactive state management with excellent performance and developer experience |
| `riverpod` | ^2.4.9 | State Management Core | Core Riverpod functionality |
| `hive` | ^2.2.3 | NoSQL Database | Fast, lightweight local database for storing user data and bookmarks |
| `hive_flutter` | ^1.1.0 | Hive Flutter Integration | Flutter-specific Hive initialization and utilities |
| `hive_generator` | ^2.0.1 | Code Generation | Generates TypeAdapters for custom classes |
| `build_runner` | ^2.4.7 | Build Tools | Required for running code generation |
| `http` | ^1.2.1 | HTTP Client | Make API calls to news services |
| `webview_flutter` | ^4.4.2 | WebView | Display full article content in embedded browser |
| `url_launcher` | ^6.2.2 | URL Handling | Open articles in external browser |
| `intl` | ^0.19.0 | Internationalization | Date formatting and localization |

### 📋 Why These Packages?

- **Hive**: Chosen over SharedPreferences for superior performance, type safety, and better data structure support. Hive is a lightweight, fast NoSQL database written in pure Dart
- **Riverpod**: Chosen over other state management solutions for its compile-time safety, excellent performance, and clean API
- **WebView Flutter**: Official Flutter plugin for displaying web content within the app
- **HTTP**: Standard package for making HTTP requests in Flutter
- **URL Launcher**: Official plugin for launching URLs in external applications
- **Intl**: Official internationalization package for date formatting

## 🗄️ Database Architecture

### HiveDatabaseManager Singleton
The app uses a centralized database manager that:
- Initializes Hive database and registers type adapters
- Manages three separate boxes: `users`, `bookmarks`, and `settings`
- Provides type-safe methods for all database operations
- Includes health checks and proper error handling
- Supports database statistics and cleanup operations

### Data Storage Strategy
- **User Sessions**: Stored in `users` box with current user data
- **Bookmarks**: Stored in `bookmarks` box using article URL as unique key
- **Settings**: Stored in `settings` box for app preferences and login status
- **Type Safety**: All operations are type-safe using generated Hive adapters

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd News_Buzz
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### 🔑 Demo Credentials

For testing the app, you can use these demo credentials:
- **Email**: `demo@example.com`
- **Password**: `password123`

Or use any valid email format with a password of at least 6 characters.

## 📱 App Screenshots

### Login Screen
- Clean and modern login interface
- Email and password validation
- Demo credentials provided for easy testing
- Session persistence using Hive database

### News Feed
- Beautiful article cards with images
- Search functionality with real-time filtering
- Pull-to-refresh for updated content
- Bookmark button with Hive storage

### Article Detail
- Full article content in WebView
- Bookmark toggle functionality
- Open in external browser option
- Loading states and error handling

### Bookmarks
- List of all saved articles from Hive
- Remove individual bookmarks
- Clear all bookmarks option
- Empty state when no bookmarks
- Persistent storage across app sessions

## 📄 Configuration

### 🚀 NewsAPI.org Setup (Primary News Source)

The app uses **NewsAPI.org** as the primary news source. To get real news data:

1. **Get a Free API Key**:
   - Visit [NewsAPI.org](https://newsapi.org/)
   - Click "Get API Key" and register for a free account
   - Copy your API key from the dashboard

2. **Configure the API Key**:
   - Open `lib/services/news_service.dart`
   - Find this line:
   ```dart
   static const String _newsApiKey = 'YOUR_API_KEY_HERE';
   ```
   - Replace `YOUR_API_KEY_HERE` with your actual API key:
   ```dart
   static const String _newsApiKey = 'your_actual_api_key_here';
   ```

3. **API Endpoint Used**:
   ```
   https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY
   ```

### 📊 API Features with NewsAPI.org:

✅ **Real-time US top headlines**  
✅ **Advanced search functionality**  
✅ **High-quality news sources**  
✅ **Rich article metadata**  
✅ **60 requests per hour (free tier)**  
✅ **Professional news sources from CNN, BBC, Reuters, etc.**

### 🔄 Automatic Fallback System:

The app includes a robust fallback system for reliability:

1. **Primary**: NewsAPI.org (when API key is configured)
2. **Backup**: HackerNews API (free, no setup required)  
3. **Final Fallback**: Mock data (ensures app always works)

### ⚠️ Without API Key:

If you don't configure a NewsAPI key, the app will:
- Show a helpful message in debug console
- Automatically use HackerNews API for tech news
- Still provide full functionality with search and bookmarks

## 🧪 Testing

The app includes comprehensive error handling and edge cases:

- **Database errors**: Graceful fallback and error recovery
- **Network errors**: Graceful fallback to cached/mock data
- **Empty states**: Proper messaging when no data is available
- **Loading states**: Visual feedback during data fetching
- **Form validation**: Client-side validation for all inputs
- **Session persistence**: Login state maintained using Hive database

## 🎯 Code Quality

- **Clean Code**: Well-commented, readable code following Dart conventions
- **Error Handling**: Comprehensive try-catch blocks with user-friendly messages
- **Performance**: Efficient state management and optimized database operations
- **Type Safety**: Full type safety with Hive TypeAdapters
- **Maintainability**: Modular architecture with clear separation of concerns
- **Scalability**: Easy to add new features and modify existing ones

## 🚀 Future Enhancements

Potential improvements for production use:

1. **Real API Integration**: Connect to actual news APIs
2. **User Authentication**: Implement proper backend authentication
3. **Push Notifications**: Notify users of breaking news
4. **Offline Support**: Enhanced offline reading with Hive cache
5. **Social Features**: Share articles on social media
6. **Personalization**: Customize news categories and sources
7. **Dark Mode**: Theme switching capability
8. **Analytics**: Track user engagement and preferences
9. **Data Sync**: Cloud synchronization of bookmarks
10. **Advanced Search**: Full-text search within saved articles

## 📄 License

This project is created for demonstration purposes as part of a Flutter development task.

---

**Built with ❤️ using Flutter and Hive Database**
