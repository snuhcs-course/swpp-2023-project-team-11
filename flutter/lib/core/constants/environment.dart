abstract class Environment {
  static const production = "http://3.35.9.226:8000";
  static const integrationTest = "http://localhost:8000";
  static bool isProduction = true;
  static String get baseUrl => isProduction?Environment.production:Environment.integrationTest;

  static void setTestMode() {
    isProduction = false;
  }
}