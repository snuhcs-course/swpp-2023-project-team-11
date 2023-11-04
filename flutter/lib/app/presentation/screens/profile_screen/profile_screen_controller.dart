import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/sign_out_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ProfileScreenController extends GetxController{
  final SignOutUseCase _signOutUseCase;

  final userController = Get.find<UserController>();

  void onLogOutButtonTap() async{
    await _signOutUseCase.call(onSuccess: onLogOutSuccess);
  }

  void onLogOutSuccess(){
    Get.offAllNamed(Routes.ENTRY);
  }

  ProfileScreenController({
    required SignOutUseCase signOutUseCase,
  }) : _signOutUseCase = signOutUseCase;
}