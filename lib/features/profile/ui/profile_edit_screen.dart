import 'package:bcsports_mobile/features/profile/data/profile_repository.dart';
import 'package:bcsports_mobile/utils/animations.dart';
import 'package:bcsports_mobile/utils/colors.dart';
import 'package:bcsports_mobile/utils/enums.dart';
import 'package:bcsports_mobile/utils/fonts.dart';
import 'package:bcsports_mobile/widgets/buttons/button.dart';
import 'package:bcsports_mobile/widgets/buttons/button_back.dart';
import 'package:bcsports_mobile/widgets/scaffold.dart';
import 'package:bcsports_mobile/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    return CustomScaffold(
        resize: true,
        color: AppColors.black,
        padding: EdgeInsets.all(sizeOf.width * 0.05),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ButtonBack(onTap: () {
                Navigator.pop(context);
              }),
              Text(
                'Edit Profile',
                style: AppFonts.font18w600,
              ),
              const SizedBox(
                width: 50,
              ),
            ],
          ),
        ),
        body: StreamBuilder(
            stream: RepositoryProvider
                .of<ProfileRepository>(context)
                .profileState
                .stream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data == LoadingStateEnum.success) {
                var user = RepositoryProvider
                    .of<ProfileRepository>(context)
                    .user;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: sizeOf.width * 0.20,
                        ),
                        InkWell(
                          onTap: () {
                            ImagePicker().pickImage(
                                source: ImageSource.gallery);
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Ink(
                            width: sizeOf.width * 0.40,
                            height: sizeOf.width * 0.40,
                            decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CustomTextFormField(
                          controller: nameController,
                          labelText: 'Name',
                          initValue: '123',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          controller: userNameController,
                          labelText: 'Username',
                          initValue: '123',
                        ),
                      ],
                    ),
                    CustomTextButton(text: 'Save', onTap: () {}, isActive: true)
                  ],
                );
              }
              else {
                return Center(child: AppAnimations.circleIndicator,);
              }
            }
        ));
  }
}
