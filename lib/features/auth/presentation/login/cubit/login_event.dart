sealed class LoginEvent {
  const LoginEvent();
}

final class EmailChangedEvent extends LoginEvent {
  final String email;
  const EmailChangedEvent(this.email);
}

final class PasswordChangedEvent extends LoginEvent {
  final String password;
  const PasswordChangedEvent(this.password);
}

final class TogglePasswordVisibilityEvent extends LoginEvent {
  const TogglePasswordVisibilityEvent();
}

final class SubmitLoginEvent extends LoginEvent {
  const SubmitLoginEvent();
}
