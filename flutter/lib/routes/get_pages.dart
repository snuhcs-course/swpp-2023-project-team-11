import 'package:get/route_manager.dart';
import 'package:mobile_app/app/presentation/screens/email_screen/email_screen.dart';
import 'package:mobile_app/app/presentation/screens/email_screen/email_screen_binding.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/entry_screen.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/entry_screen_binding.dart';
import 'package:mobile_app/routes/named_routes.dart';

import '../app/presentation/screens/country_screen/country_screen.dart';
import '../app/presentation/screens/country_screen/country_screen_binding.dart';

abstract class GetPages {
  static get pages => [
        GetPage(
          name: Routes.ENTRY,
          page: () => const EntryScreen(),
          binding: EntryScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY+ Routes.COUNTRY,
          page: () => const CountryScreen(),
          binding: CountryScreenBinding(),
        ),
        GetPage(
          name: Routes.ENTRY+ Routes.COUNTRY + Routes.EMAIL,
          page: () => const EmailScreen(),
          binding: EmailScreenBinding(),
        ),
      ];
}
