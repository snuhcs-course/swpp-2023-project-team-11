
import 'package:mobile_app/app/domain/models/intimacy.dart';
import 'package:mobile_app/app/domain/repository_interfaces/roadmap_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class UpdateIntimacyUseCase{
  final RoadmapRepository _roadmapRepository;

  Future<void> call({
    required int chattingRoomId,
    required void Function(Intimacy intimacy) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _roadmapRepository.updateIntimacy(chattingRoomId: chattingRoomId);
    switch (result) {
      case Success(:final data):
        print("updating intimacy success");
        whenSuccess(data);
      case Fail(:final issue):
        print("updating intimacy fail");
        whenFail();
    }
  }

  const UpdateIntimacyUseCase({
    required RoadmapRepository roadmapRepository,
  }) : _roadmapRepository = roadmapRepository;
}