extension UrlExention on String {
  bool isValidUrl() => RegExp(
          r'(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?')
      .hasMatch(this);
}
