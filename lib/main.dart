import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_quiz_full_app/cubits/app_cubit.dart';
import 'package:new_quiz_full_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:new_quiz_full_app/cubits/questions_cubit/questions_cubit.dart';
import 'package:new_quiz_full_app/cubits/quizzes_cubit/quizzes_cubit.dart';
import 'package:new_quiz_full_app/cubits/results_cubit/results_cubit.dart';
import 'package:new_quiz_full_app/screens/intro_screen.dart';
import 'package:new_quiz_full_app/screens/register_screen.dart';
import 'package:new_quiz_full_app/utlis/audio_player_utils.dart';

import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppAudioPlayer.initializeAudioPlayer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
        create: (context) => AppCubit(),
        ),
        BlocProvider(
        create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => QuestionsCubit(),
        ),
        BlocProvider(
          create: (context) => QuizzesCubit(),
        ),
        BlocProvider(
          create: (context) => ResultsCubit(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: FirebaseAuth.instance.currentUser !=null ?const IntroScreen():const RegisterScreen(),
      ),
    );
  }
}

/*class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).title,
        ),
      ),
      body: Row(
        children: [
          Text(
            S.of(context).hello,
            style: TextStyle(fontSize: 30.0),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: isArabic() ? 16.0 : 0,
              left: isArabic() ? 0 : 16.0,
            ),
            child: Text(
              S.of(context).world,
              style: TextStyle(fontSize: 30.0),
            ),
          ),
        ],
      ),
    );
  }

  bool isArabic() {
    return Intl.getCurrentLocale() == "ar";
  }
}*/


// test for another example :))
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IntrinsicHeight(
              child: Stack(
                children: <Widget>[
                  Image.network('https://i.imgur.com/MUuCuYI.png'),
                  Align(
                    alignment: Alignment(.66 * 2 - 1 , .12 * 2 - 1),
                    child: Image.asset(
                      "assets/animal images/butterfly.png",
                      width: 50,
                    ),
                  ),
                  Align(
                    alignment: Alignment(.536 * 2 - 1, .274 * 2 - 1),
                    child: Text('cloud'),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Image.asset(
                  "assets/animal images/butterfly.png",
                  width: 40,
                ),
                Checkbox(
                  value: value,
                  onChanged: (newVal) {
                    setState(() {
                      value= newVal!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
