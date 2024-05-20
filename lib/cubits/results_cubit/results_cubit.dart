import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  ResultsCubit() : super(ResultsInitial());
}
