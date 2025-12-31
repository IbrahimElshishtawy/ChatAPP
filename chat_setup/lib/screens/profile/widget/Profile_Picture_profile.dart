import 'dart:io';

import 'package:chat_setup/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.userCtrl});

  final UserController userCtrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          await userCtrl.updateProfilePicture(File(image.path));
        }
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: userCtrl.user.value?.profilePicture != null
            ? NetworkImage(userCtrl.user.value!.profilePicture!)
            : const AssetImage('assets/default_avatar.png') as ImageProvider,
        child: userCtrl.user.value?.profilePicture == null
            ? const Icon(Icons.camera_alt, color: Colors.white)
            : null,
      ),
    );
  }
}
