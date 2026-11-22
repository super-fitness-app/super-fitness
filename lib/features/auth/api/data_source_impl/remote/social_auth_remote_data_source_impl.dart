import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/social_auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/social_auth_user_model.dart';

@Injectable(as: SocialAuthRemoteDataSource)
class SocialAuthRemoteDataSourceImpl implements SocialAuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseAuth _firebaseAuth;

  SocialAuthRemoteDataSourceImpl(
    this._googleSignIn,
    this._facebookAuth,
    this._firebaseAuth,
  );

  @override
  Future<SocialAuthUserModel?> signInWithGoogle() async {
    try {
      // 1. Sign out previous Google session to ensure account picker opens
      await _googleSignIn.signOut();

      // 2. Trigger Google Sign-In dialog
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Reserved strictly for genuine user cancellation
        return null;
      }

      // 3. Obtain authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // 4. Authenticate with Firebase using Google credentials
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      // 5. If Firebase fails to create or return the user, throw an explicit exception
      // (Do NOT return null, as that conflates Firebase failures with user cancellations)
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Firebase user creation failed after Google authentication',
        );
      }

      // 6. Map and return user data with robust fallbacks
      return SocialAuthUserModel(
        id: user.uid,
        email: user.email ?? googleUser.email,
        displayName: (user.displayName != null && user.displayName!.isNotEmpty)
            ? user.displayName!
            : (googleUser.displayName ?? ''),
        photoUrl: user.photoURL ?? googleUser.photoUrl,
      );
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SocialAuthUserModel?> signInWithFacebook() async {
    try {
      // 1. Sign out previous Facebook session to ensure clean dialog state
      try {
        await _facebookAuth.logOut();
      } catch (_) {}

      // 2. Trigger Facebook Login dialog
      final LoginResult loginResult = await _facebookAuth.login(
        permissions: const ['email', 'public_profile'],
      );

      // 3. Handle user cancellation
      if (loginResult.status == LoginStatus.cancelled) {
        return null;
      }

      // 4. Handle non-success or missing access token
      if (loginResult.status != LoginStatus.success ||
          loginResult.accessToken == null) {
        throw Exception(loginResult.message ?? 'Facebook sign in failed');
      }

      // 5. Obtain Firebase credential with Facebook access token
      final AuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      // 6. Authenticate with Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message:
              'Firebase user creation failed after Facebook authentication',
        );
      }

      // 7. Fallback to Facebook Graph API if email or display name is missing from Firebase
      Map<String, dynamic>? fbUserData;
      if (user.email == null ||
          user.email!.isEmpty ||
          user.displayName == null ||
          user.displayName!.isEmpty) {
        try {
          fbUserData = await _facebookAuth.getUserData();
        } catch (_) {}
      }

      final fbEmail = fbUserData?['email'] as String?;
      final fbName = fbUserData?['name'] as String?;
      final fbPhoto =
          (fbUserData?['picture'] as Map?)?['data']?['url'] as String?;

      return SocialAuthUserModel(
        id: user.uid,
        email: user.email ?? fbEmail ?? '',
        displayName: (user.displayName != null && user.displayName!.isNotEmpty)
            ? user.displayName!
            : (fbName ?? ''),
        photoUrl: user.photoURL ?? fbPhoto,
      );
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
      _firebaseAuth.signOut(),
    ]);
  }
}
