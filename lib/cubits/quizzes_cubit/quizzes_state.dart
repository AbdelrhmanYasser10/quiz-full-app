part of 'quizzes_cubit.dart';

@immutable
sealed class QuizzesState {}

final class QuizzesInitial extends QuizzesState {}

class GetAllQuizzesLoading extends QuizzesState{}
class GetAllQuizzesSuccess extends QuizzesState{}
class GetAllQuizzesError extends QuizzesState{}