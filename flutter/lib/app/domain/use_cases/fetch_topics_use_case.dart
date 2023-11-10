import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/domain/repository_interfaces/roadmap_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class FetchTopicsUseCase {
  final RoadmapRepository _roadmapRepository;
  Future<void> call({
    required int chattingRoomId,
    required void Function(List<Topic> topics) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _roadmapRepository.readTopics(chattingRoomId: chattingRoomId);
    switch (result) {
      case Success(:final data):
        whenSuccess(data);
      case Fail(:final issue):
        whenFail();
    }
  }

  const FetchTopicsUseCase({
    required RoadmapRepository roadmapRepository,
  }) : _roadmapRepository = roadmapRepository;
}
