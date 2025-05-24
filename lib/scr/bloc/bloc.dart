// lib/blocs/counter_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:immobilier_apk/scr/bloc/envent.dart';
import 'package:immobilier_apk/scr/bloc/state.dart';


class CounterBloc extends Bloc<CounterEvent, CounterState> {
  int _count = 0;

  CounterBloc() : super(CounterInitial());

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is IncrementEvent) {
      _count++;
      yield CounterChanged(_count);
    } else if (event is DecrementEvent) {
      _count--;
      yield CounterChanged(_count);
    }
  }
}
