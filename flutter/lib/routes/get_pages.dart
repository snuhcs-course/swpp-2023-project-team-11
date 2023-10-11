import 'package:get/route_manager.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/entry_screen.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/entry_screen_binding.dart';
import 'package:mobile_app/routes/named_routes.dart';

abstract class GetPages {
  static get pages => [
    GetPage(
      name: Routes.ENTRY,
      page: () => const EntryScreen(),
      binding: EntryScreenBinding(),
    ),
  ];
}
