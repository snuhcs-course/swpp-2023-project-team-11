import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/email_service.dart';

class EmailCodeUseCase {
  final EmailService _emailService;

  Future<void> call({required String email, required void Function() onSuccess, required void Function() onFail}) async {
    if(!email.endsWith("@snu.ac.kr")) onFail();
    else{
      final emailCodeResult = await _emailService.requestEmail(email: email);

      switch (emailCodeResult) {
        case Success(:final data):{
          onSuccess();
        }case Fail(:final issue):{
        onFail();
      }
      }
    }


  }

  EmailCodeUseCase({required EmailService emailService})
      : _emailService = emailService;
}
