import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/posts_repository.dart';
import '../../data/post_model.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository _postsRepository;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  PostsBloc({required PostsRepository postsRepository})
    : _postsRepository = postsRepository,
      super(PostsState.initial()) {
    // Register event handlers
    on<LoadPostsEvent>(_onLoadPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<SyncUnsyncedPostsEvent>(_onSyncUnsyncedPosts);
    on<CheckConnectivityEvent>(_onCheckConnectivity);

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      add(const CheckConnectivityEvent());

      // Auto-sync when internet is restored
      if (results.isNotEmpty &&
          results.first != ConnectivityResult.none &&
          state.unsyncedCount > 0) {
        add(const SyncUnsyncedPostsEvent());
      }
    });

    // Initial load
    add(const LoadPostsEvent());
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(state.copyWith(status: PostsStatus.loading));

    try {
      // Load posts with offline-first strategy
      final posts = await _postsRepository.fetchPosts();
      final unsyncedCount = await _postsRepository.getUnsyncedPostsCount();

      emit(
        state.copyWith(
          status: PostsStatus.loaded,
          posts: posts,
          unsyncedCount: unsyncedCount,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PostsStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final posts = await _postsRepository.refreshPosts();
      final unsyncedCount = await _postsRepository.getUnsyncedPostsCount();

      emit(
        state.copyWith(
          status: PostsStatus.loaded,
          posts: posts,
          unsyncedCount: unsyncedCount,
          isRefreshing: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      // If refresh fails, keep current posts
      emit(
        state.copyWith(
          isRefreshing: false,
          errorMessage: 'Failed to refresh: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCreatePost(
    CreatePostEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      final newPost = PostModel(
        userId: event.userId,
        title: event.title,
        body: event.body,
        createdAt: DateTime.now(),
      );

      final createdPost = await _postsRepository.createPost(newPost);

      // Add to current posts list
      final updatedPosts = [createdPost, ...state.posts];
      final unsyncedCount = await _postsRepository.getUnsyncedPostsCount();

      emit(state.copyWith(posts: updatedPosts, unsyncedCount: unsyncedCount));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Failed to create post: ${e.toString()}'),
      );
    }
  }

  Future<void> _onUpdatePost(
    UpdatePostEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      final updatedPost = await _postsRepository.updatePost(event.post);

      // Update in posts list
      final updatedPosts = state.posts.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();

      final unsyncedCount = await _postsRepository.getUnsyncedPostsCount();

      emit(state.copyWith(posts: updatedPosts, unsyncedCount: unsyncedCount));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Failed to update post: ${e.toString()}'),
      );
    }
  }

  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      final success = await _postsRepository.deletePost(event.post);

      if (success) {
        // Remove from posts list
        final updatedPosts = state.posts
            .where((post) => post.id != event.post.id)
            .toList();
        final unsyncedCount = await _postsRepository.getUnsyncedPostsCount();

        emit(state.copyWith(posts: updatedPosts, unsyncedCount: unsyncedCount));
      }
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Failed to delete post: ${e.toString()}'),
      );
    }
  }

  Future<void> _onSyncUnsyncedPosts(
    SyncUnsyncedPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state.unsyncedCount == 0) return;

    emit(state.copyWith(status: PostsStatus.syncing));

    try {
      await _postsRepository.syncUnsyncedPosts();

      // Reload posts after sync
      final posts = await _postsRepository.getCachedPosts();
      final unsyncedCount = await _postsRepository.getUnsyncedPostsCount();

      emit(
        state.copyWith(
          status: PostsStatus.loaded,
          posts: posts,
          unsyncedCount: unsyncedCount,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PostsStatus.loaded,
          errorMessage: 'Failed to sync: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivityEvent event,
    Emitter<PostsState> emit,
  ) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isConnected =
        connectivityResults.isNotEmpty &&
        connectivityResults.first != ConnectivityResult.none;

    emit(state.copyWith(isConnected: isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
