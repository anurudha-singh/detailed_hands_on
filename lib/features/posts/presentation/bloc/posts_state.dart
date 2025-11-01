import 'package:equatable/equatable.dart';
import '../../data/post_model.dart';

enum PostsStatus { initial, loading, loaded, error, syncing }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<PostModel> posts;
  final String? errorMessage;
  final bool isConnected;
  final int unsyncedCount;
  final bool isRefreshing;

  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.errorMessage,
    this.isConnected = false,
    this.unsyncedCount = 0,
    this.isRefreshing = false,
  });

  static PostsState initial() {
    return const PostsState();
  }

  PostsState copyWith({
    PostsStatus? status,
    List<PostModel>? posts,
    String? errorMessage,
    bool? isConnected,
    int? unsyncedCount,
    bool? isRefreshing,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
      isConnected: isConnected ?? this.isConnected,
      unsyncedCount: unsyncedCount ?? this.unsyncedCount,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    status,
    posts,
    errorMessage,
    isConnected,
    unsyncedCount,
    isRefreshing,
  ];
}
