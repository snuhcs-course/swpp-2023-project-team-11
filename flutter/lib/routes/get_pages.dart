import 'package:get/route_manager.dart';
import 'package:mobile_app/app/presentation/screens/additional_profile_info_screen/additional_profile_info_screen.dart';
import 'package:mobile_app/app/presentation/screens/additional_profile_info_screen/additional_profile_info_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/chatting_rooms_screen/chatting_rooms_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/email_screen/email_screen.dart';
import 'package:mobile_app/app/presentation/screens/email_screen/email_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/entry_screen.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/entry_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/friend_detail_screen/friend_detail_screen.dart';
import 'package:mobile_app/app/presentation/screens/friend_detail_screen/friend_detail_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/friends_screen/friends_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/main_screen/main_indexed_screen.dart';
import 'package:mobile_app/app/presentation/screens/main_screen/main_indexed_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/profile_screen/profile_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/profile_survey_screen.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/profile_survey_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/room_screen/room_screen.dart';
import 'package:mobile_app/app/presentation/screens/room_screen/room_screen_binding.dart';
import 'package:mobile_app/routes/middle_ware.dart';
import 'package:mobile_app/routes/named_routes.dart';

import '../app/presentation/screens/chat_requests_screen/chat_requests_screen.dart';
import '../app/presentation/screens/chat_requests_screen/chat_requests_screen_binding.dart';
import '../app/presentation/screens/country_screen/country_screen.dart';
import '../app/presentation/screens/country_screen/country_screen_binding.dart';
import '../app/presentation/screens/make_profile_screen/make_profile_screen.dart';
import '../app/presentation/screens/make_profile_screen/make_profile_screen_binding.dart';
import '../app/presentation/screens/password_screen/password_screen.dart';
import '../app/presentation/screens/password_screen/password_screen_binding.dart';

abstract class GetPages {
  static get pages => [
        GetPage(
          name: Routes.ENTRY,
          page: () => const EntryScreen(),
          binding: EntryScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY + Routes.COUNTRY,
          page: () => const CountryScreen(),
          binding: CountryScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY + Routes.COUNTRY + Routes.EMAIL,
          page: () => const EmailScreen(),
          binding: EmailScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY + Routes.COUNTRY + Routes.EMAIL + Routes.PASSWORD,
          page: () => const PasswordScreen(),
          binding: PasswordScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY +
              Routes.COUNTRY +
              Routes.EMAIL +
              Routes.PASSWORD +
              Routes.ADDITIONAL_INFO,
          page: () => const AdditionalProfileInfoScreen(),
          binding: AdditionalProfileInfoScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY +
              Routes.COUNTRY +
              Routes.EMAIL +
              Routes.PASSWORD +
              Routes.ADDITIONAL_INFO +
              Routes.MAKE_PROFILE,
          page: () => const MakeProfileScreen(),
          binding: MakeProfileScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY +
              Routes.COUNTRY +
              Routes.EMAIL +
              Routes.PASSWORD +
              Routes.ADDITIONAL_INFO +
              Routes.MAKE_PROFILE +
              Routes.PROFILE_SURVEY,
          page: () => const ProfileSurveyScreen(),
          binding: ProfileSurveyScreenBinding(),
        ),
        GetPage(
          name: Routes.MAIN,
          page: () => const MainIndexedScreen(),
          bindings: [
            MainIndexedScreenBinding(),
            FriendsScreenBinding(),
            ChattingRoomsScreenBinding(),
            ProfileScreenBinding(),
          ],
          middlewares: [
            MainMiddleWare(),
          ],
        ),
        GetPage(
          name: Routes.MAIN + Routes.FRIEND_DETAIL,
          page: () => const FriendDetailScreen(),
          binding: FriendDetailScreenBinding(),
        ),
        GetPage(
          name: Routes.MAIN + Routes.CHAT_REQUESTS,
          page: () => const ChatRequestsScreen(),
          binding: ChatRequestsScreenBinding(),
        ),
        GetPage(
          name: Routes.MAIN + Routes.ROOM,
          page: () => const RoomScreen(),
          binding: RoomScreenBinding(),
        ),
      ];
}
