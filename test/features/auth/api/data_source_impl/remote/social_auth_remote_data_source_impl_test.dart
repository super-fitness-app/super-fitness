import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:super_fitness/features/auth/api/data_source_impl/remote/social_auth_remote_data_source_impl.dart';

class FakeAccessToken extends Fake implements AccessToken {
  @override
  final String tokenString;

  FakeAccessToken({required this.tokenString});
}

class FakeFacebookAuth extends Fake implements FacebookAuth {
  LoginResult? loginResultToReturn;
  Map<String, dynamic> userDataToReturn = {};
  Exception? exceptionToThrow;
  int logOutCallCount = 0;
  int loginCallCount = 0;

  @override
  Future<void> logOut() async {
    logOutCallCount++;
  }

  @override
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    LoginBehavior loginBehavior = LoginBehavior.nativeWithFallback,
    LoginTracking loginTracking = LoginTracking.limited,
    String? nonce,
  }) async {
    loginCallCount++;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return loginResultToReturn!;
  }

  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) async {
    return userDataToReturn;
  }
}

class FakeGoogleSignInAccount extends Fake implements GoogleSignInAccount {
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String? photoUrl;
  final GoogleSignInAuthentication auth;

  FakeGoogleSignInAccount({
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.auth,
  });

  @override
  Future<GoogleSignInAuthentication> get authentication async => auth;
}

class FakeGoogleSignInAuthentication extends Fake
    implements GoogleSignInAuthentication {
  @override
  final String? idToken;
  @override
  final String? accessToken;

  FakeGoogleSignInAuthentication({this.idToken, this.accessToken});
}

class FakeGoogleSignIn extends Fake implements GoogleSignIn {
  GoogleSignInAccount? accountToReturn;
  Exception? exceptionToThrow;
  int signOutCallCount = 0;
  int signInCallCount = 0;
  List<String> callOrder = [];

  @override
  Future<GoogleSignInAccount?> signOut() async {
    signOutCallCount++;
    callOrder.add('signOut');
    return null;
  }

  @override
  Future<GoogleSignInAccount?> signIn() async {
    signInCallCount++;
    callOrder.add('signIn');
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return accountToReturn;
  }
}

class FakeUser extends Fake implements User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;

  FakeUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });
}

class FakeUserCredential extends Fake implements UserCredential {
  @override
  final User? user;

  FakeUserCredential({this.user});
}

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  UserCredential? credentialToReturn;
  Exception? exceptionToThrow;
  AuthCredential? capturedCredential;
  int signOutCallCount = 0;

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    capturedCredential = credential;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return credentialToReturn!;
  }

  @override
  Future<void> signOut() async {
    signOutCallCount++;
  }
}

void main() {
  group('SocialAuthRemoteDataSourceImpl Tests', () {
    late FakeGoogleSignIn fakeGoogleSignIn;
    late FakeFacebookAuth fakeFacebookAuth;
    late FakeFirebaseAuth fakeFirebaseAuth;
    late SocialAuthRemoteDataSourceImpl dataSource;

    final fakeAuth = FakeGoogleSignInAuthentication(
      idToken: 'test_id_token',
      accessToken: 'test_access_token',
    );

    final fakeGoogleAccount = FakeGoogleSignInAccount(
      email: 'google.user@example.com',
      displayName: 'Google User',
      photoUrl: 'https://example.com/google.png',
      auth: fakeAuth,
    );

    final fakeFirebaseUser = FakeUser(
      uid: 'firebase_uid_123',
      email: 'firebase.user@example.com',
      displayName: 'Firebase User',
      photoURL: 'https://example.com/firebase.png',
    );

    setUp(() {
      fakeGoogleSignIn = FakeGoogleSignIn();
      fakeFacebookAuth = FakeFacebookAuth();
      fakeFirebaseAuth = FakeFirebaseAuth();
      dataSource = SocialAuthRemoteDataSourceImpl(
        fakeGoogleSignIn,
        fakeFacebookAuth,
        fakeFirebaseAuth,
      );
    });

    test(
      'signInWithGoogle calls signOut before signIn to ensure account picker opens',
      () async {
        fakeGoogleSignIn.accountToReturn = fakeGoogleAccount;
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(
          user: fakeFirebaseUser,
        );

        await dataSource.signInWithGoogle();

        expect(fakeGoogleSignIn.callOrder, equals(['signOut', 'signIn']));
        expect(fakeGoogleSignIn.signOutCallCount, equals(1));
        expect(fakeGoogleSignIn.signInCallCount, equals(1));
      },
    );

    test(
      'signInWithGoogle returns null when user cancels Google Sign-In',
      () async {
        fakeGoogleSignIn.accountToReturn = null;

        final result = await dataSource.signInWithGoogle();

        expect(result, isNull);
        expect(fakeFirebaseAuth.capturedCredential, isNull);
      },
    );

    test(
      'signInWithGoogle completes full flow and maps to SocialAuthUserModel correctly',
      () async {
        fakeGoogleSignIn.accountToReturn = fakeGoogleAccount;
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(
          user: fakeFirebaseUser,
        );

        final result = await dataSource.signInWithGoogle();

        expect(result, isNotNull);
        expect(result!.id, equals('firebase_uid_123'));
        expect(result.email, equals('firebase.user@example.com'));
        expect(result.displayName, equals('Firebase User'));
        expect(result.photoUrl, equals('https://example.com/firebase.png'));
        expect(fakeFirebaseAuth.capturedCredential, isNotNull);
      },
    );

    test(
      'signInWithGoogle falls back to googleUser fields when firebase user fields are null',
      () async {
        fakeGoogleSignIn.accountToReturn = fakeGoogleAccount;
        final userWithNullFields = FakeUser(
          uid: 'firebase_uid_fallback',
          email: null,
          displayName: null,
          photoURL: null,
        );
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(
          user: userWithNullFields,
        );

        final result = await dataSource.signInWithGoogle();

        expect(result, isNotNull);
        expect(result!.id, equals('firebase_uid_fallback'));
        expect(result.email, equals('google.user@example.com'));
        expect(result.displayName, equals('Google User'));
        expect(result.photoUrl, equals('https://example.com/google.png'));
      },
    );

    test(
      'signInWithGoogle throws FirebaseAuthException when userCredential.user is null',
      () async {
        fakeGoogleSignIn.accountToReturn = fakeGoogleAccount;
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(user: null);

        expect(
          () => dataSource.signInWithGoogle(),
          throwsA(
            isA<FirebaseAuthException>()
                .having(
                  (e) => e.code,
                  'code',
                  equals('user-not-found'),
                )
                .having(
                  (e) => e.message,
                  'message',
                  equals('Firebase user creation failed after Google authentication'),
                ),
          ),
        );
      },
    );

    test(
      'signInWithGoogle propagates FirebaseAuthException thrown by signInWithCredential',
      () async {
        fakeGoogleSignIn.accountToReturn = fakeGoogleAccount;
        fakeFirebaseAuth.exceptionToThrow = FirebaseAuthException(
          code: 'network-request-failed',
          message: 'A network error occurred.',
        );

        expect(
          () => dataSource.signInWithGoogle(),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              equals('network-request-failed'),
            ),
          ),
        );
      },
    );

    test(
      'signInWithGoogle propagates unexpected exceptions thrown by GoogleSignIn',
      () async {
        fakeGoogleSignIn.exceptionToThrow = Exception('Google sign in failed');

        expect(
          () => dataSource.signInWithGoogle(),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
        'signOut calls signOut on Google, logOut on Facebook, and signOut on Firebase',
        () async {
      await dataSource.signOut();

      expect(fakeGoogleSignIn.signOutCallCount, equals(1));
      expect(fakeFacebookAuth.logOutCallCount, equals(1));
      expect(fakeFirebaseAuth.signOutCallCount, equals(1));
    });

    test('signInWithFacebook returns null when user cancels', () async {
      fakeFacebookAuth.loginResultToReturn = LoginResult(
        status: LoginStatus.cancelled,
      );

      final result = await dataSource.signInWithFacebook();

      expect(result, isNull);
      expect(fakeFacebookAuth.logOutCallCount, equals(1));
      expect(fakeFacebookAuth.loginCallCount, equals(1));
    });

    test(
      'signInWithFacebook returns SocialAuthUserModel when Facebook and Firebase succeed',
      () async {
        fakeFacebookAuth.loginResultToReturn = LoginResult(
          status: LoginStatus.success,
          accessToken: FakeAccessToken(tokenString: 'fb_token_123'),
        );
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(
          user: fakeFirebaseUser,
        );

        final result = await dataSource.signInWithFacebook();

        expect(result, isNotNull);
        expect(result!.id, equals('firebase_uid_123'));
        expect(result.email, equals('firebase.user@example.com'));
        expect(result.displayName, equals('Firebase User'));
        expect(result.photoUrl, equals('https://example.com/firebase.png'));
      },
    );

    test('signInWithFacebook throws Exception when login status is failed', () async {
      fakeFacebookAuth.loginResultToReturn = LoginResult(
        status: LoginStatus.failed,
        message: 'Network error during Facebook login',
      );

      expect(
        () => dataSource.signInWithFacebook(),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'signInWithFacebook throws FirebaseAuthException when Firebase user is null',
      () async {
        fakeFacebookAuth.loginResultToReturn = LoginResult(
          status: LoginStatus.success,
          accessToken: FakeAccessToken(tokenString: 'fb_token_123'),
        );
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(user: null);

        expect(
          () => dataSource.signInWithFacebook(),
          throwsA(
            isA<FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              equals('user-not-found'),
            ),
          ),
        );
      },
    );

    test(
      'signInWithFacebook falls back to getUserData Graph API when Firebase user lacks email/name',
      () async {
        final incompleteUser = FakeUser(
          uid: 'fb_uid_999',
          email: null,
          displayName: null,
          photoURL: null,
        );
        fakeFacebookAuth.loginResultToReturn = LoginResult(
          status: LoginStatus.success,
          accessToken: FakeAccessToken(tokenString: 'fb_token_fallback'),
        );
        fakeFacebookAuth.userDataToReturn = {
          'email': 'fb.graph@example.com',
          'name': 'Graph User',
          'picture': {
            'data': {'url': 'https://graph.facebook.com/pic.png'},
          },
        };
        fakeFirebaseAuth.credentialToReturn = FakeUserCredential(
          user: incompleteUser,
        );

        final result = await dataSource.signInWithFacebook();

        expect(result, isNotNull);
        expect(result!.id, equals('fb_uid_999'));
        expect(result.email, equals('fb.graph@example.com'));
        expect(result.displayName, equals('Graph User'));
        expect(result.photoUrl, equals('https://graph.facebook.com/pic.png'));
      },
    );
  });
}
