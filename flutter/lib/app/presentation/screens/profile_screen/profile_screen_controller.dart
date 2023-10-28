import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/sign_out_use_case.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ProfileScreenController extends GetxController{
  final SignOutUseCase _signOutUseCase;

  final user = Get.find<User>();

  void onLogOutButtonTap() async{
    await _signOutUseCase.call(onSuccess: onLogOutSuccess);
    Get.delete<User>(force: true);
  }

  void onLogOutSuccess(){
    Get.offAllNamed(Routes.ENTRY);
  }

  ProfileScreenController({
    required SignOutUseCase signOutUseCase,
  }) : _signOutUseCase = signOutUseCase;
}