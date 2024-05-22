part of 'results_cubit.dart';

@immutable
sealed class ResultsState {}

final class ResultsInitial extends ResultsState {}
final class ResultsLoading extends ResultsState {}
final class ResultsLoadedSuccessfully extends ResultsState {}
final class ResultsLoadedWithError extends ResultsState {}
