import 'package:mobile_app/app/domain/models/user.dart';

abstract class UserRepository {
  /// API : 현재 헤더에 자동으로 담겨있는 세션을 바탕으로 유저를 불러온다
  /// endPoint : /users/me
  ///
  /// <request>
  ///
  /// <response>
  /// User 를 리턴한다.
  Future<User> readUserBySessionId();

  /// API : 현재 헤더에 자동으로 담겨있는 세션을 바탕으로 유저목록을 불러온다
  /// 혹시 리퀘스트에서 유저 Profile 정보를 담는 것이 쿼리상 효율을 올려주신다면 포함하겠습니다
  /// 일단 프로필 정보는 서버에서 세션 아이디 갖다가 알아서 불러와서 처리한다고 생각하고 이래 했습니다.
  /// endPoint : /users/logic
  ///
  /// <request>
  ///
  /// <response>
  /// User의 목록을 리턴한다. 몇개 리스폰스할지는 알아서 정해주세요
  /// 추후에, refetch시에는 어떻게 하고 이런 Pagination 관련해서 논의가 필요할 수도 있겠네요
  Future<List<User>> readUsersBasedOnLogic();
}