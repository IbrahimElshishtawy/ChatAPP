import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_setup/screens/home/widgets/floating_nav_bar.dart';
import 'package:chat_setup/screens/profile/widget/Complete_Profile_Button.dart';
import 'package:chat_setup/screens/profile/widget/Contact_Button_profile.dart';
import 'package:chat_setup/screens/profile/widget/Description_user_profile.dart';
import 'package:chat_setup/screens/profile/widget/Profile_Picture_profile.dart';
import 'package:chat_setup/screens/profile/widget/Share_pprofile_Button.dart';
import 'package:chat_setup/screens/profile/widget/Stats_Section_profile.dart';
import 'package:chat_setup/screens/profile/widget/User_Info_profile.dart';
import 'package:chat_setup/screens/profile/widget/User_Posts_profile.dart';

import '../../controllers/user/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final UserController userCtrl;

  late TextEditingController nameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController usernameCtrl;
  late TextEditingController descriptionCtrl;

  @override
  void initState() {
    super.initState();
    userCtrl = Get.find<UserController>();

    final user = userCtrl.user.value;
    nameCtrl = TextEditingController(text: user?.name ?? '');
    phoneCtrl = TextEditingController(text: user?.phone ?? '');
    usernameCtrl = TextEditingController(text: user?.username ?? '');
    descriptionCtrl = TextEditingController(text: user?.description ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    usernameCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/editProfile'),
          ),
        ],
      ),

      body: Obx(() {
        final user = userCtrl.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isProfileComplete =
            user.name.isNotEmpty &&
            user.phone != null &&
            user.username != null &&
            user.description != null &&
            user.profilePicture != null;

        return Stack(
          children: [
            /// المحتوى القابل للتمرير
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProfilePicture(userCtrl: userCtrl),
                      const SizedBox(width: 16),
                      const Expanded(child: StatsSection()),
                    ],
                  ),

                  const SizedBox(height: 16),

                  UserInfo(
                    nameCtrl: nameCtrl,
                    phoneCtrl: phoneCtrl,
                    usernameCtrl: usernameCtrl,
                  ),

                  const SizedBox(height: 16),

                  DescriptionSection(descriptionCtrl: descriptionCtrl),

                  const SizedBox(height: 16),

                  if (!isProfileComplete) ...[
                    const CompleteProfileButton(),
                    const SizedBox(height: 16),
                  ],

                  Row(
                    children: const [
                      Expanded(child: ShareButton()),
                      SizedBox(width: 16),
                      Expanded(child: ContactButton()),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'My Posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),

                  /// ⚠️ مهم جدًا: UserPostsWidget لازم يكون بدون Scroll داخلي
                  UserPostsWidget(userId: user.id),
                ],
              ),
            ),

            /// Floating Nav Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingNavBar(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
