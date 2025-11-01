import 'package:equatable/equatable.dart';
import '../../data/post_model.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostsEvent {
  const LoadPostsEvent();
}

class RefreshPostsEvent extends PostsEvent {
  const RefreshPostsEvent();
}

class CreatePostEvent extends PostsEvent {
  final String title;
  final String body;
  final int userId;

  const CreatePostEvent({
    required this.title,
    required this.body,
    required this.userId,
  });

  @override
  List<Object> get props => [title, body, userId];
}

class UpdatePostEvent extends PostsEvent {
  final PostModel post;

  const UpdatePostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends PostsEvent {
  final PostModel post;

  const DeletePostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

class SyncUnsyncedPostsEvent extends PostsEvent {
  const SyncUnsyncedPostsEvent();
}

class CheckConnectivityEvent extends PostsEvent {
  const CheckConnectivityEvent();
}
