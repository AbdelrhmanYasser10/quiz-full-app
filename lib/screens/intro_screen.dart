import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quiz_full_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:new_quiz_full_app/cubits/quizzes_cubit/quizzes_cubit.dart';
import 'package:new_quiz_full_app/screens/all_quizes_screen.dart';
import 'package:new_quiz_full_app/screens/register_screen.dart';
import 'package:new_quiz_full_app/utlis/audio_player_utils.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with WidgetsBindingObserver {
  List<IconData> icons = [
    FontAwesomeIcons.play,
    FontAwesomeIcons.question,
    FontAwesomeIcons.timeline,
    Icons.logout,
  ];
  List<String> titles = [
    "Play",
    "Terms",
    "Results",
    "Logout",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // continue sound playing
      AppAudioPlayer.playSound();
    } else if (state == AppLifecycleState.inactive) {
      // stop playing the sound
      AppAudioPlayer.stopSound();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden || state == AppLifecycleState.detached) {
      // pause the sound
      AppAudioPlayer.stopSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LogOutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        else if(state is LogOutSuccessfully){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const RegisterScreen()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: state is LogOutLoading ? const CircularProgressIndicator(
                  color: Colors.black,
                ):Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to my QUIZ App",
                      style: GoogleFonts.manrope(
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20.0,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (index == 0 || index == 2) {
                              QuizzesCubit.get(context).getAllQuizzes();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AllQuizzesScreen(
                                    isPlay: index == 0,
                                  ),
                                ),
                              );
                            } else if (index == 3) {
                              AuthCubit.get(context).logOutFn(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  icons[index],
                                  color: Colors.white,
                                  size: 64.0,
                                ),
                                Text(
                                  titles[index],
                                  style: GoogleFonts.manrope(
                                    textStyle: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
