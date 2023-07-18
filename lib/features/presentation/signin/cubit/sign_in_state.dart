// ignore_for_file: constant_identifier_names

part of 'sign_in_cubit.dart';

enum SignInStatus {
  INIT,
  LOADING,
  LOADED,
  ERROR,
}

class SignInState extends Equatable {
  final SignInStatus status;

  const SignInState({
    required this.status,
  });

  SignInState copyWith({
    SignInStatus? status,
  }) {
    return SignInState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
