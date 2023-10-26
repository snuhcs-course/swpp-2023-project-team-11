import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/email_service.dart';

class EmailVerifyUseCase {
  final EmailService _emailService;

  Future<void> call({required String email, required int codeInput, required void Function(String) onSuccess, required void Function() onFail}) async {
    final emailVerifyResult = await _emailService.verifyEmailCode(email: email, emailCode: codeInput);

    switch (emailVerifyResult) {
      case Success(:final data):{
        onSuccess(data.token);
      }case Fail(:final issue):{
        onFail();
      }
    }
  }

  EmailVerifyUseCase({required EmailService emailService})
      : _emailService = emailService;
}
