# 📱 Offline-First Posts App

## 🎯 Implementation of Question 4: Offline-First Data Handling

### ✨ Features Implemented

✅ **Offline-First Architecture**
- Fetches and caches API data (posts from JSONPlaceholder)
- Shows cached data first, then refreshes from network
- Works completely offline after initial data load

✅ **SQLite Database Integration**
- Custom database with posts table
- Automatic schema creation and management
- Efficient CRUD operations

✅ **Network Connectivity Handling**
- Real-time connectivity status monitoring
- Smart offline/online behavior switching
- Visual indicators for connection status

✅ **Offline Sync Capability** (BONUS)
- Creates posts offline when no internet
- Marks offline-created items as "unsynced"
- Auto-syncs when internet is restored
- Manual sync option available

---

## 🏗 Architecture

### **Clean Architecture Layers**

```
📁 features/posts/
├── 📁 data/
│   ├── post_model.dart          # Data model with SQLite mapping
│   ├── posts_database.dart      # SQLite database helper
│   ├── posts_api_service.dart   # HTTP API service
│   └── posts_repository.dart    # Repository with offline-first logic
└── 📁 presentation/
    ├── 📁 bloc/
    │   ├── posts_bloc.dart       # Business logic (BLoC)
    │   ├── posts_event.dart      # Events
    │   └── posts_state.dart      # States
    └── 📁 screens/
        ├── posts_screen.dart     # Main posts list
        └── create_post_screen.dart # Create/edit posts
```

---

## 🚀 Key Features

### 1. **Offline-First Data Strategy**
```dart
// Repository automatically handles offline-first logic
Future<List<PostModel>> fetchPosts() async {
  // 1. Return cached data immediately if available
  List<PostModel> cachedPosts = await _database.getAllPosts();
  if (cachedPosts.isNotEmpty) {
    _refreshFromNetwork(); // Background refresh
    return cachedPosts;
  }
  
  // 2. Fetch from network if no cache
  if (await _isConnected()) {
    final networkPosts = await _apiService.fetchPosts();
    await _database.insertPosts(networkPosts); // Cache it
    return networkPosts;
  }
}
```

### 2. **Smart Sync System**
```dart
// Posts are marked as synced/unsynced
class PostModel {
  final bool isSync; // Tracks sync status
  // ... other fields
}

// Auto-sync when internet is restored
_connectivitySubscription = Connectivity()
    .onConnectivityChanged
    .listen((results) {
      if (hasInternet && state.unsyncedCount > 0) {
        add(const SyncUnsyncedPostsEvent());
      }
    });
```

### 3. **Visual Feedback**
- 🟢 **Green WiFi Icon**: Connected to internet
- 🔴 **Red WiFi-Off Icon**: No internet connection
- 🟠 **Orange Badge**: Shows unsynced items count
- 🔄 **Sync Button**: Manual sync when online
- 📶 **Status Banners**: Real-time sync status

---

## 📊 Database Schema

```sql
CREATE TABLE posts(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  isSync INTEGER NOT NULL DEFAULT 1,  -- 1=synced, 0=unsynced
  createdAt TEXT NOT NULL,
  updatedAt TEXT
)
```

---

## 🎮 How to Use

### **Running the Demo**
```bash
cd /Users/anurudha.singh/AndroidStudioProjects/detailed_hands_on
flutter run lib/posts_demo_main.dart
```

### **Testing Offline Functionality**

1. **Initial Load**: App fetches 100 posts from JSONPlaceholder API
2. **Go Offline**: Turn off device internet/WiFi
3. **Offline Use**: Posts still load from cache, can create new posts
4. **Create Posts**: New posts are marked as "Local" (unsynced)
5. **Go Online**: Turn internet back on
6. **Auto-Sync**: App automatically syncs offline posts to server

---

## 🧪 Testing Scenarios

### ✅ **Scenario 1: First Launch (Online)**
- App fetches posts from API
- Caches all posts in SQLite
- Shows "Synced" status on all posts

### ✅ **Scenario 2: Subsequent Launch (Offline)**
- App shows cached posts immediately
- No loading spinner (instant load)
- Connection indicator shows offline

### ✅ **Scenario 3: Create Post (Offline)**
- User creates post without internet
- Post saved locally with "Local" badge
- Orange unsynced counter appears

### ✅ **Scenario 4: Internet Restored**
- Connectivity listener detects internet
- Auto-sync begins (blue banner shows)
- Posts marked as "Synced" after successful upload

### ✅ **Scenario 5: Background Refresh**
- Pull-to-refresh updates cache
- Refresh button fetches latest posts
- Cache updated silently in background

---

## 🔧 Technical Highlights

### **Dependencies Used**
```yaml
dependencies:
  flutter_bloc: ^9.1.1      # State management
  sqflite: ^2.4.2           # Local SQLite database
  http: ^1.1.0              # HTTP requests
  connectivity_plus: ^6.0.5 # Network monitoring
  equatable: ^2.0.7         # Value equality
```

### **BLoC Pattern Implementation**
- Clean separation of business logic
- Reactive UI updates
- Proper error handling
- Loading and success states

### **Error Handling**
- Network timeout handling
- Database connection errors
- Graceful degradation
- User-friendly error messages

---

## 🏆 Bonus Features Implemented

✅ **Auto-sync when internet restores**
✅ **Real-time connectivity monitoring**  
✅ **Visual sync status indicators**
✅ **Pull-to-refresh functionality**
✅ **Edit existing posts**
✅ **Delete posts (with server sync)**
✅ **Background cache refresh**
✅ **Optimistic UI updates**

---

## 🎯 Interview Discussion Points

1. **Why SQLite over Hive?**
   - Better for complex queries
   - Mature ecosystem
   - SQL familiarity
   - Better data relationships

2. **Offline-First Strategy Benefits**
   - Improved user experience
   - Works in poor network conditions
   - Faster app responsiveness
   - Reduced server load

3. **Sync Conflict Resolution**
   - Last-write-wins strategy
   - Could implement versioning
   - Server timestamp comparison
   - Merge strategies for conflicts

4. **Performance Considerations**
   - Database indexing for fast queries
   - Pagination for large datasets
   - Background operations
   - Memory management

---

## 🚀 Ready for Production

This implementation demonstrates:
- ✅ Production-ready architecture
- ✅ Proper error handling
- ✅ User experience considerations
- ✅ Scalable code structure
- ✅ Testing-friendly design
- ✅ Performance optimizations

**Perfect for senior-level Flutter interviews!** 🎯
