part of 'quizzes_cubit.dart';

@immutable
sealed class QuizzesState {}

final class QuizzesInitial extends QuizzesState {}

class GetAllQuizzesLoading extends QuizzesState{}
class GetAllQuizzesSuccess extends QuizzesState{}
class GetAllQuizzesError extends QuizzesState{}

class GetSolvedQuizzesLoading extends QuizzesState{}
class GetSolvedQuizzesSuccess extends QuizzesState{
final String quizId;
GetSolvedQuizzesSuccess({required this.quizId});
}
class GetSolvedQuizzesError extends QuizzesState{
final String quizId;
GetSolvedQuizzesError({required this.quizId});
}