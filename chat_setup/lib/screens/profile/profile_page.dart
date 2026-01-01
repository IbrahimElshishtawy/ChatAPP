import 'package:chat_setup/screens/home/widgets/floating_nav_bar.dart';
import 'package:chat_setup/screens/profile/widget/Complete_Profile_Button.dart';
import 'package:chat_setup/screens/profile/widget/Contact_Button_profile.dart';
import 'package:chat_setup/screens/profile/widget/Description_user_profile.dart';
import 'package:chat_setup/screens/profile/widget/Profile_Picture_profile.dart';
import 'package:chat_setup/screens/profile/widget/Share_pprofile_Button.dart';
import 'package:chat_setup/screens/profile/widget/Stats_Section_profile.dart';
import 'package:chat_setup/screens/profile/widget/User_Info_profile.dart';
import 'package:chat_setup/screens/profile/widget/User_Posts_profile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Stack(
        children: [
          // The body of the profile page with scrollable content
          SingleChildScrollView(
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
                  // Profile Picture and Stats section
                  Row(
                    children: [
                      ProfilePicture(userCtrl: userCtrl),
                      const SizedBox(width: 16),
                      StatsSection(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // User Information (Name, Phone, Username)
                  UserInfo(
                    nameCtrl: nameCtrl,
                    phoneCtrl: phoneCtrl,
                    usernameCtrl: usernameCtrl,
                  ),
                  const SizedBox(height: 16),

                  // Description section
                  DescriptionSection(descriptionCtrl: descriptionCtrl),
                  const SizedBox(height: 16),

                  // Complete Profile Button if the profile is incomplete
                  if (!isProfileComplete) CompleteProfileButton(),
                  const SizedBox(height: 16),

                  // Share and Contact Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShareButton(),
                      const SizedBox(width: 16),
                      ContactButton(),
                    ],
                  ),

                  // User Posts section
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'My Posts',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  UserPostsWidget(userId: user.id),
                ],
              );
            }),
          ),

          // FloatingNavBar stays at the bottom of the screen
          const Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: FloatingNavBar(),
          ),
        ],
      ),
    );
  }
}
