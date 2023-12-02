abstract class ProxyIdGenerator {
  static int getByNowTime() {
    return DateTime.now().millisecondsSinceEpoch~/10;
  }
}