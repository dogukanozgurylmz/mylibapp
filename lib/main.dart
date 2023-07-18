import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mylib_app/features/data/model/book_model.dart';
import 'package:mylib_app/features/data/model/user_model.dart';
import 'package:mylib_app/features/data/model/model_adapters/book_model_adapter.dart';

import 'features/presentation/addbook/book_add_view.dart';
import 'features/presentation/addbookcase/add_bookcase_view.dart';
import 'features/presentation/bookcase_details/bookcase_details_view.dart';
import 'features/presentation/home/home_view.dart';
import 'features/presentation/profile/profile_view.dart';
import 'features/presentation/signin/sign_in_view.dart';
import 'features/presentation/splash/splash_view.dart';
import 'features/presentation/statistic/statistic_view.dart';
import 'firebase_options.dart';
import 'features/data/model/model_adapters/user_model_adapters.dart';

Future<void> main() async {
  await initializeDateFormatting('tr_TR', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  Hive.registerAdapter<BookModel>(BookModelAdapter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // İlk açılışta SplashView sayfasını açar
      routes: {
        '/': (context) => SplashView(),
        '/home': (context) => const HomeView(),
        '/signin': (context) => const SignInView(),
        '/addbook': (context) => const AddBookView(),
        '/profile': (context) => const ProfileView(),
        '/addbookcase': (context) => const AddBookcaseView(),
        '/bookcasedetails': (context) => const BookcaseDetailsView(),
        '/statistic': (context) => const StatisticView(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text('Bir şeyler ters gitti'),
          ),
        ),
      ),
      title: 'myLib App',
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
