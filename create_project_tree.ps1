# ==============================
# Chat App Project Structure
# ==============================

$folders = @(
    "lib/app",
    "lib/app/routes",
    "lib/app/bindings",

    "lib/core/constants",
    "lib/core/models",
    "lib/core/services",
    "lib/core/utils",
    "lib/core/theme",

    "lib/controllers/auth",
    "lib/controllers/user",
    "lib/controllers/chat",
    "lib/controllers/group",
    "lib/controllers/archive",
    "lib/controllers/notification",
    "lib/controllers/community",
    "lib/controllers/call",

    "lib/screens/splash",
    "lib/screens/auth",
    "lib/screens/home",
    "lib/screens/chat",
    "lib/screens/group",
    "lib/screens/community",
    "lib/screens/profile",
    "lib/screens/notifications",
    "lib/screens/search",
    "lib/screens/call",

    "lib/widgets/buttons",
    "lib/widgets/dialogs",
    "lib/widgets/inputs",
    "lib/widgets/common"
)

$files = @(
    "lib/main.dart",

    "lib/app/app.dart",
    "lib/app/routes.dart",
    "lib/app/bindings.dart",

    "lib/core/constants/app_colors.dart",
    "lib/core/constants/app_strings.dart",
    "lib/core/constants/firestore_paths.dart",

    "lib/core/models/user_model.dart",
    "lib/core/models/chat_model.dart",
    "lib/core/models/message_model.dart",
    "lib/core/models/group_model.dart",
    "lib/core/models/notification_model.dart",
    "lib/core/models/community_post_model.dart",
    "lib/core/models/call_model.dart",

    "lib/core/services/auth_service.dart",
    "lib/core/services/user_service.dart",
    "lib/core/services/chat_service.dart",
    "lib/core/services/group_service.dart",
    "lib/core/services/notification_service.dart",
    "lib/core/services/community_service.dart",
    "lib/core/services/call_service.dart",

    "lib/core/utils/chat_id_helper.dart",
    "lib/core/utils/password_helper.dart",
    "lib/core/utils/date_helper.dart",
    "lib/core/utils/validators.dart",

    "lib/controllers/auth/auth_controller.dart",
    "lib/controllers/user/user_controller.dart",
    "lib/controllers/chat/chat_controller.dart",
    "lib/controllers/chat/private_chat_controller.dart",
    "lib/controllers/group/group_controller.dart",
    "lib/controllers/archive/archive_controller.dart",
    "lib/controllers/notification/notification_controller.dart",
    "lib/controllers/community/community_controller.dart",
    "lib/controllers/call/call_controller.dart",

    "lib/screens/splash/splash_page.dart",

    "lib/screens/auth/login_page.dart",
    "lib/screens/auth/register_page.dart",

    "lib/screens/home/home_page.dart",

    "lib/screens/chat/chat_page.dart",
    "lib/screens/chat/private_chat_lock_page.dart",
    "lib/screens/chat/archived_chats_page.dart",

    "lib/screens/group/groups_page.dart",
    "lib/screens/group/group_chat_page.dart",

    "lib/screens/community/community_page.dart",

    "lib/screens/profile/profile_page.dart",
    "lib/screens/profile/edit_profile_page.dart",

    "lib/screens/notifications/notifications_page.dart",

    "lib/screens/search/search_page.dart",

    "lib/screens/call/incoming_call_page.dart",
    "lib/screens/call/voice_call_page.dart",
    "lib/screens/call/video_call_page.dart",

    "lib/widgets/buttons/primary_button.dart",
    "lib/widgets/dialogs/password_dialog.dart",
    "lib/widgets/dialogs/confirm_dialog.dart",
    "lib/widgets/inputs/custom_text_field.dart",
    "lib/widgets/common/loading_widget.dart"
)

Write-Host "Creating folders..."
foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
}

Write-Host "Creating files..."
foreach ($file in $files) {
    New-Item -ItemType File -Force -Path $file | Out-Null
}

Write-Host "✅ Project structure created successfully!"
