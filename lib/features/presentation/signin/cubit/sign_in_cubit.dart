import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mylib_app/features/core/result/data_result.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/user_local_datasource_impl.dart';
import 'package:mylib_app/features/data/model/user_model.dart';

import '../../../data/repository/impl/auth_repository_impl.dart';
import '../../../data/repository/impl/user_repository_impl.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required AuthRepositoryImpl authRepositoryImpl,
    required UserRepositoryImpl userRepositoryImpl,
    required UserLocalDatasourceImpl userLocalDatasourceImpl,
  })  : _authRepositoryImpl = authRepositoryImpl,
        _userRepositoryImpl = userRepositoryImpl,
        _userLocalDatasourceImpl = userLocalDatasourceImpl,
        super(const SignInState(
          status: SignInStatus.INIT,
        ));

  final AuthRepositoryImpl _authRepositoryImpl;
  final UserRepositoryImpl _userRepositoryImpl;
  final UserLocalDatasourceImpl _userLocalDatasourceImpl;

  Future<void> signInWithGoogle() async {
    // Box<UserModel> box = await Hive.openBox<UserModel>('users');
    // box.clear();
    emit(state.copyWith(status: SignInStatus.LOADING));
    DataResult<User> user = await _authRepositoryImpl.signInWithGoogle();

    if (user != null) {
      await _userLocalDatasourceImpl.clear();
      DataResult<UserModel> usermodel =
          await _userRepositoryImpl.getUserByEmail(user.data!.email ?? "");
      if (usermodel.success) {
        _userLocalDatasourceImpl.create(usermodel.data!);
        emit(state.copyWith(status: SignInStatus.LOADED));
        return;
      }
      UserModel userModel = UserModel(
        id: '',
        fullName: user.data!.displayName ?? "",
        photoUrl: user.data!.photoURL ?? "",
        email: user.data!.email ?? "",
        createdAt: DateTime.now(),
      );
      await _userRepositoryImpl.createUser(userModel);
      await _userLocalDatasourceImpl.create(userModel);
      emit(state.copyWith(status: SignInStatus.LOADED));
    } else {
      emit(state.copyWith(status: SignInStatus.ERROR));
    }
  }

  void resetSignInStatus() {
    emit(state.copyWith(status: SignInStatus.INIT));
  }
}
