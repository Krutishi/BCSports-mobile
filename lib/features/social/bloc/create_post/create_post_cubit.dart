import 'dart:typed_data';

import 'package:bcsports_mobile/features/profile/data/profile_repository.dart';
import 'package:bcsports_mobile/features/social/data/models/post_model.dart';
import 'package:bcsports_mobile/features/social/data/social_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final SocialRepository _socialRepository;
  final ProfileRepository _profileRepository;

  CreatePostCubit(
      SocialRepository socialRepository, ProfileRepository profileRepository)
      : _socialRepository = socialRepository,
        _profileRepository = profileRepository,
        super(CreatePostInitial());

  void createPost(String? text, [XFile? image]) async {
    emit(CreateLoadingState());
    try {
      PostImageDTO? imageDTO;
      if (image != null) imageDTO = await _uploadImages(image);

      await _socialRepository.createPost(PostModel.create(
          creatorId: _profileRepository.user.id, text: text, image: imageDTO));

      _profileRepository.getUserPosts();

      emit(CreateSuccessState());
    } catch (e) {
      emit(CreateFailState(e as Exception));
    }
  }

  Future<PostImageDTO> _uploadImages(XFile image) async {
    String imageUrl;
    String compressedImageUrl;

    final List<Future> waitFor = [];
    waitFor.add(_socialRepository.uploadPostImage(filePath: image.path));
    waitFor.add(_compressImageAndUpload(image));

    final results = await Future.wait(waitFor);

    imageUrl = results[0];
    compressedImageUrl = results[1];

    return PostImageDTO(
        imageUrl: imageUrl, compressedImageUrl: compressedImageUrl);
  }

  Future<String> _compressImageAndUpload(XFile image) async {
    final compressedImage = await _compressImage(await image.readAsBytes());
    return _socialRepository.uploadPostImage(bytes: compressedImage);
  }

  Future<Uint8List> _compressImage(Uint8List list) =>
      FlutterImageCompress.compressWithList(
        list,
        minWidth: 120,
        minHeight: 60,
      );
}

class PostImageDTO {
  final String? imageUrl;
  final String? compressedImageUrl;

  PostImageDTO({required this.imageUrl, required this.compressedImageUrl});
}
