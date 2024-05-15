part of 'questions_cubit.dart';

@immutable
sealed class QuestionsState {}

final class QuestionsInitial extends QuestionsState {}
class GetDataLoading extends QuestionsState{}
class GetDataSuccessfully extends QuestionsState{}
class GetDataError extends QuestionsState{}
