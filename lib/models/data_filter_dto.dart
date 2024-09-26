class DataFilter {
  final int id;
  final String name;

  const DataFilter({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }
}
