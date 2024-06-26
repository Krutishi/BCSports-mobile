import 'package:bcsports_mobile/features/profile/data/profile_repository.dart';
import 'package:bcsports_mobile/features/social/data/models/comment_model.dart';
import 'package:bcsports_mobile/features/social/data/models/comment_view_model.dart';
import 'package:bcsports_mobile/features/social/data/models/post_view_model.dart';
import 'package:bcsports_mobile/features/social/data/post_source.dart';
import 'package:bcsports_mobile/features/social/data/social_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'post_comments_state.dart';

class PostCommentsCubit extends Cubit<PostCommentsState> {
  final SocialRepository _socialRepository;
  final ProfileRepository _profileRepository;

  PostCommentsCubit(
      SocialRepository socialRepository, ProfileRepository profileRepository)
      : _socialRepository = socialRepository,
        _profileRepository = profileRepository,
        super(PostCommentsInitial());

  final List<CommentViewModel> comments = [];
  PostViewModel? post;
  PostSource? source;

  void closePost() {
    comments.clear();
    post = null;
    source = null;
  }

  Future sendComment(String text) async {
    emit(CreatingComment());
    final comment = CommentModel.create(
        text, _profileRepository.user.id, post!.postModel.id);
    final createdComment = await _socialRepository.createComment(comment);
    comments.insert(0, createdComment);

    emit(CommentCreateSuccess());
  }

  Future likeComment(CommentViewModel commentViewModel) async {
    commentViewModel.setLike(!commentViewModel.liked);
    commentViewModel.setLikesCount(commentViewModel.likesCount + (commentViewModel.liked ? 1 : -1));
    emit(CommentCreateSuccess());
    if (commentViewModel.liked) {
      _profileRepository.commentLikes.add(commentViewModel.commentId);
    } else {
      _profileRepository.commentLikes.remove(commentViewModel.commentId);
    }

    await _socialRepository.updateUserCommentsLikes(
        commentViewModel.liked,
        commentViewModel.commentId,
        _profileRepository.user.id,
        _profileRepository.commentLikes);

    emit(CommentCreateSuccess());
  }

  void setPost(PostViewModel newPost, PostSource newSource) async {
    post = newPost;
    source = newSource;
    emit(PostCommentsLoadingState());
    try {
      comments.addAll(
          await _socialRepository.getPostComments(newPost.postModel.id));

      print(_profileRepository.commentLikes);

      for (var i in comments) {
        i.setLike(_profileRepository.commentLikes.contains(i.commentId));
      }

      emit(PostCommentsSuccessState());
    } catch (e) {
      emit(PostCommentsFailState());
      rethrow;
    }
  }

  void refreshComments() async {
    emit(PostCommentsLoadingState());
    try {
      comments
          .addAll(await _socialRepository.getPostComments(post!.postModel.id));
      emit(PostCommentsSuccessState());
    } catch (e) {
      emit(PostCommentsFailState());
      rethrow;
    }
  }
}
