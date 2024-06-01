import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  void register({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(RegisterLoading());
    try {
      // create account using email and password
      /*UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password,
      );
      if(user.user != null){
        await _database.
        collection("users").
        doc(user.user!.uid).
        set({
          'id':user.user!.uid,
          'email':email,
          'username':username,
        });*/
      // create account using only username
      UserCredential user = await _auth.signInAnonymously();
      if (user.user != null) {
        await _database.collection("users").doc(user.user!.uid).set({
          'id': user.user!.uid,
          //'email':email,
          'username': username,
          'finishedAll': false,
        });
        emit(RegisterSuccessfully());
      } else {
        emit(RegisterError(message: "Failed to register"));
      }
    } catch (error) {
      emit(RegisterError(message: "Failed to register"));
    }
  }

  void logOutFn({required String userId}) async {
    emit(LogOutLoading());
    try {
      int lengthOfAllQuizzes =
          (await _database.collection("quizes").get()).docs.length;
      int answersLength = (await _database
              .collection("users")
              .doc(userId)
              .collection("results")
              .get())
          .docs
          .length;
      if (lengthOfAllQuizzes == answersLength) {
        await _database.collection("users").doc(userId).update({
          'finishedAll': true,
        });
        await _auth.signOut();
        emit(LogOutSuccessfully());
      } else {
        emit(LogOutError(
            message: "You can not logout until finish all quizzes"));
      }
    } catch (error) {
      emit(LogOutError(message: "Internal Server Error, try again later"));
    }
  }
}
