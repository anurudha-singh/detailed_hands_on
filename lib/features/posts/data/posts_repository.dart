import 'package:connectivity_plus/connectivity_plus.dart';
import 'post_model.dart';
import 'posts_database.dart';
import 'posts_api_service.dart';

class PostsRepository {
  final PostsDatabase _database = PostsDatabase();
  final PostsApiService _apiService = PostsApiService();
  final Connectivity _connectivity = Connectivity();

  // Check if device is connected to internet
  Future<bool> _isConnected() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.isNotEmpty &&
        connectivityResults.first != ConnectivityResult.none;
  }

  // Fetch posts with offline-first strategy
  Future<List<PostModel>> fetchPosts() async {
    try {
      // First, get cached data
      List<PostModel> cachedPosts = await _database.getAllPosts();

      // If we have cached data, return it immediately
      if (cachedPosts.isNotEmpty) {
        // Try to refresh from network in background
        _refreshFromNetwork();
        return cachedPosts;
      }

      // If no cached data, try to fetch from network
      if (await _isConnected()) {
        final networkPosts = await _apiService.fetchPosts();

        // Cache the fetched data
        await _database.clearAllPosts();
        await _database.insertPosts(networkPosts);

        return networkPosts;
      } else {
        // No internet and no cache
        throw Exception('No internet connection and no cached data available');
      }
    } catch (e) {
      // If network fails, return cached data if available
      List<PostModel> cachedPosts = await _database.getAllPosts();
      if (cachedPosts.isNotEmpty) {
        return cachedPosts;
      }
      rethrow;
    }
  }

  // Refresh from network (background operation)
  Future<void> _refreshFromNetwork() async {
    try {
      if (await _isConnected()) {
        final networkPosts = await _apiService.fetchPosts();

        // Update cache with fresh data
        await _database.clearAllPosts();
        await _database.insertPosts(networkPosts);

        print('Cache refreshed from network');
      }
    } catch (e) {
      print('Failed to refresh from network: $e');
    }
  }

  // Force refresh from network
  Future<List<PostModel>> refreshPosts() async {
    if (await _isConnected()) {
      final networkPosts = await _apiService.fetchPosts();

      // Update cache
      await _database.clearAllPosts();
      await _database.insertPosts(networkPosts);

      return networkPosts;
    } else {
      throw Exception('No internet connection');
    }
  }

  // Create post (offline-first)
  Future<PostModel> createPost(PostModel post) async {
    if (await _isConnected()) {
      try {
        // Try to create on server
        final serverPost = await _apiService.createPost(post);

        // Cache the server response
        await _database.insertPost(serverPost);

        return serverPost;
      } catch (e) {
        // If server fails, save locally as unsynced
        final unsyncedPost = post.copyWith(isSync: false);
        final localId = await _database.insertPost(unsyncedPost);
        return unsyncedPost.copyWith(id: localId);
      }
    } else {
      // Save locally as unsynced
      final unsyncedPost = post.copyWith(isSync: false);
      final localId = await _database.insertPost(unsyncedPost);
      return unsyncedPost.copyWith(id: localId);
    }
  }

  // Update post
  Future<PostModel> updatePost(PostModel post) async {
    if (await _isConnected() && post.isSync) {
      try {
        // Try to update on server
        final serverPost = await _apiService.updatePost(post);

        // Update local cache
        await _database.updatePost(serverPost);

        return serverPost;
      } catch (e) {
        // If server fails, mark as unsynced
        final unsyncedPost = post.copyWith(
          isSync: false,
          updatedAt: DateTime.now(),
        );
        await _database.updatePost(unsyncedPost);
        return unsyncedPost;
      }
    } else {
      // Update locally as unsynced
      final unsyncedPost = post.copyWith(
        isSync: false,
        updatedAt: DateTime.now(),
      );
      await _database.updatePost(unsyncedPost);
      return unsyncedPost;
    }
  }

  // Delete post
  Future<bool> deletePost(PostModel post) async {
    if (await _isConnected() && post.isSync && post.id != null) {
      try {
        // Try to delete on server
        final success = await _apiService.deletePost(post.id!);

        if (success) {
          // Delete from local cache
          await _database.deletePost(post.id!);
          return true;
        }
        return false;
      } catch (e) {
        // If server fails, just delete locally
        await _database.deletePost(post.id!);
        return true;
      }
    } else {
      // Delete locally
      if (post.id != null) {
        await _database.deletePost(post.id!);
        return true;
      }
      return false;
    }
  }

  // Sync unsynced posts when internet is restored
  Future<List<PostModel>> syncUnsyncedPosts() async {
    if (!await _isConnected()) {
      throw Exception('No internet connection');
    }

    final unsyncedPosts = await _database.getUnsyncedPosts();
    List<PostModel> syncedPosts = [];

    for (PostModel post in unsyncedPosts) {
      try {
        if (post.id != null && post.id! < 0) {
          // This is a locally created post, create on server
          final serverPost = await _apiService.createPost(post);
          await _database.markPostAsSynced(post.id!, serverPost.id!);
          syncedPosts.add(serverPost);
        } else {
          // This is an updated post, update on server
          final serverPost = await _apiService.updatePost(post);
          await _database.updatePost(serverPost.copyWith(isSync: true));
          syncedPosts.add(serverPost);
        }
      } catch (e) {
        print('Failed to sync post ${post.id}: $e');
      }
    }

    return syncedPosts;
  }

  // Get all posts from local cache
  Future<List<PostModel>> getCachedPosts() async {
    return await _database.getAllPosts();
  }

  // Get unsynced posts count
  Future<int> getUnsyncedPostsCount() async {
    final unsyncedPosts = await _database.getUnsyncedPosts();
    return unsyncedPosts.length;
  }

  // Check if has cached data
  Future<bool> hasCachedData() async {
    return await _database.hasData();
  }
}
