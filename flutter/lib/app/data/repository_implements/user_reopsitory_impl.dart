import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/repository_interfaces/user_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> readUserBySessionId() {
    // TODO: implement readUserBySessionId
    throw UnimplementedError();
  }

  @override
  Future<Result<List<User>, DefaultIssue>> readUsersBasedOnLogic() {
    // TODO: implement readUsersBasedOnLogic
    throw UnimplementedError();
  }

}