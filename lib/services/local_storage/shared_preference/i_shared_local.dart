abstract class IStorageService<T> {
  String key = "";

  IStorageService(this.key);

  Future<void> set({
    required T data,
  });

  Future<T?> get({
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<List<T>?> getList({
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<bool> remove();
}
