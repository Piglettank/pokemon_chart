extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
