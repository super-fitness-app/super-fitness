abstract final class Endpoints {
  static const String baseUrl = 'https://fitness.elevateegy.com/api/v1/';
  // Auth Endpoints
  static const String loginEndPoint = 'auth/signin';
  static const String register = 'auth/signup';
  static const String changePassword = 'auth/change-password';
  static const String forgetPassword = 'auth/forgotPassword';
  static const String verifyOtp = 'auth/verifyResetCode';
  static const String resetPassword = 'auth/resetPassword';
  static const String deleteAccount = 'auth/deleteMe';

  // Smart Coach AI / Ollama Endpoints
  static const String ollamaAndroidHost = 'http://10.0.2.2:11434/api/chat';
  static const String ollamaDesktopHost = 'http://localhost:11434/api/chat';
  static const String ollamaDefaultModel = 'gemma4:e2b';
  static const String ollamaCloudModel = 'gemma4:31b-cloud';
}
