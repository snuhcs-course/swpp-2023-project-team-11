import 'package:mobile_app/app/data/service_implements/auth_service_impl.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';

class DependencyManager {
  final AuthService authService;

  const DependencyManager({
    required this.authService,
  });

  DependencyManager copyWith({
    AuthService? authService,
  }) {
    return DependencyManager(
      authService: authService ?? this.authService,
    );
  }

  factory DependencyManager.basic() {
    return const DependencyManager(
      authService: AuthServiceImpl(),
    );
  }
}
