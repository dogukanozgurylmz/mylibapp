import 'package:firebase_auth/firebase_auth.dart';

import '../../core/result/data_result.dart';
import '../../core/result/result.dart';

abstract class AuthRepository {
  Future<DataResult<User>> signInWithGoogle();
  Future<Result> signOut();
}
