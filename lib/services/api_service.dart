class ApiConfig {
  static const String baseUrl = 'http://192.168.2.109:8000';
  static const String apiEndpoint = '$baseUrl/api';
  static const String googleAuthRedirect = '$apiEndpoint/auth/google/redirect';
  static const String facebookAuthRedirect =
      '$apiEndpoint/auth/facebook/redirect';
}
