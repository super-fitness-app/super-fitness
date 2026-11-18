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
}
