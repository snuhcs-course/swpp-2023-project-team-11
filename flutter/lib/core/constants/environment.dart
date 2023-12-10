abstract class Environment {
  static const production = "http://3.35.9.226:8000";
  static const integrationTest = "http://localhost:8000";

  static const productionSocketUrl = "ws://3.35.9.226:8000/ws/connect";
  static const integrationTestSocketUrl = "ws://localhost:8000/ws/connect";

  static bool isProduction = true;
  static String get baseUrl => isProduction?Environment.production:Environment.integrationTest;
  static String get socketUrl => isProduction?productionSocketUrl:integrationTestSocketUrl;

  static void setTestMode() {
    isProduction = false;
  }
}