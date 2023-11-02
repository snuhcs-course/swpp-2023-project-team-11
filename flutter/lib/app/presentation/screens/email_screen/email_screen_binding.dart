import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/service_implements/email_service_impl.dart';
import 'package:mobile_app/app/domain/use_cases/email_code_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/email_verify_use_case.dart';
import 'email_screen_controller.dart';

class EmailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EmailScreenController(
        emailCodeUseCase: EmailCodeUseCase(emailService: EmailServiceImpl()),
        emailVerifyUseCase:
            EmailVerifyUseCase(emailService: EmailServiceImpl())));
  }
}
