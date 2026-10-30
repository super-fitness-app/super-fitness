import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/social_auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/social_auth_user_model.dart';

@Injectable(as: SocialAuthRemoteDataSource)
class SocialAuthRemoteDataSourceImpl implements SocialAuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  SocialAuthRemoteDataSourceImpl(this._googleSignIn, this._firebaseAuth);

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
          code: AppStrings.firebaseUserNotFoundCode,
          message: AppStrings.firebaseUserCreationFailed,
        );
      }

      // 6. Map and return user data with robust fallbacks
      return SocialAuthUserModel(
        id: user.uid,
        email: user.email ?? googleUser.email,
        displayName: (user.displayName != null && user.displayName!.isNotEmpty)
            ? user.displayName!
            : (googleUser.displayName ?? AppStrings.emptyString),
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
  Future<SocialAuthUserModel?> signInWithFacebook() {
    /// Todo: Implement Facebook sign-in logic here
    throw UnimplementedError(AppStrings.facebookNotImplemented);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([_googleSignIn.signOut(), _firebaseAuth.signOut()]);
  }
}
