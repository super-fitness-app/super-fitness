import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/social_auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/social_auth_user_model.dart';

@Injectable(as: SocialAuthRemoteDataSource)
class SocialAuthRemoteDataSourceImpl implements SocialAuthRemoteDataSource {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  SocialAuthRemoteDataSourceImpl(
    this._googleSignIn,
    this._firebaseAuth,
  );

  @override
  Future<SocialAuthUserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user == null) {
      return null;
    }

    return SocialAuthUserModel(
      id: user.uid,
      email: user.email ?? googleUser.email,
      displayName: user.displayName ?? googleUser.displayName ?? '',
      photoUrl: user.photoURL ?? googleUser.photoUrl,
    );
  }

  @override
  Future<SocialAuthUserModel?> signInWithFacebook() {
    throw UnimplementedError('Facebook sign in is not implemented yet');
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
  }
}
