part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

class AddNewAnswer extends AppState{}
class TimeOutState extends AppState{}
class QuizFinished extends AppState{}
class ResultsCalculated extends AppState{}


