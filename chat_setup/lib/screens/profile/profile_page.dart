import 'dart:io';
import 'package:chat_setup/screens/profile/widget/Complete_Profile_Button.dart';
import 'package:chat_setup/screens/profile/widget/Contact_Button_profile.dart';
import 'package:chat_setup/screens/profile/widget/Description_user_profile.dart';
import 'package:chat_setup/screens/profile/widget/Profile_Picture_profile.dart';
import 'package:chat_setup/screens/profile/widget/Share_pprofile_Button.dart';
import 'package:chat_setup/screens/profile/widget/Stats_Section_profile.dart';
import 'package:chat_setup/screens/profile/widget/User_Info_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/user/user_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = Get.find<UserController>();
    final nameCtrl = TextEditingController(
      text: userCtrl.user.value?.name ?? '',
    );
    final phoneCtrl = TextEditingController(
      text: userCtrl.user.value?.phone ?? '',
    );
    final descriptionCtrl = TextEditingController(
      text: userCtrl.user.value?.description ?? '',
    );
    final usernameCtrl = TextEditingController(
      text: userCtrl.user.value?.username ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.toNamed('/editProfile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final user = userCtrl.user.value;
          if (user == null) return const CircularProgressIndicator();

          bool isProfileComplete =
              user.name.isNotEmpty &&
              user.phone != null &&
              user.username != null &&
              user.description != null &&
              user.profilePicture != null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfilePicture(userCtrl: userCtrl),
              const SizedBox(height: 6),
              StatsSection(),
              const SizedBox(height: 16),
              UserInfo(
                nameCtrl: nameCtrl,
                phoneCtrl: phoneCtrl,
                usernameCtrl: usernameCtrl,
              ),
              const SizedBox(height: 16),
              DescriptionSection(descriptionCtrl: descriptionCtrl),
              const SizedBox(height: 16),
              if (!isProfileComplete) CompleteProfileButton(),
              const SizedBox(height: 16),
              ShareButton(),
              const SizedBox(height: 16),
              ContactButton(),
            ],
          );
        }),
      ),
    );
  }
}
