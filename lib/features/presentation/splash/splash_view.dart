import 'package:flutter/material.dart';
import 'package:mylib_app/features/data/repository/impl/auth_repository_impl.dart';

import '../home/home_view.dart';
import '../signin/sign_in_view.dart';

class SplashView extends StatelessWidget {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = _authRepository.currentUser;
    if (currentUser == null) {
      return const SignInView();
    } else {
      return const HomeView();
    }
  }
}
