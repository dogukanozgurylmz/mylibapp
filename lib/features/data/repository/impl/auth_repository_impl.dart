import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mylib_app/features/data/repository/auth_repository.dart';

import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<DataResult<User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      return DataResult.success("Google sign-in success", data: user!);
    } catch (e) {
      return DataResult.fail("Google sign-in failed");
    }
  }

  User? get currentUser => _auth.currentUser;

  @override
  Future<Result> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return Result.success("Sign-out success");
    } catch (e) {
      return Result.fail("Sign-out failed");
    }
  }
}
