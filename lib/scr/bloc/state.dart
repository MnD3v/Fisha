// lib/blocs/counter_state.dart
abstract class CounterState {}

class CounterInitial extends CounterState {}

class CounterChanged extends CounterState {
  final int count;
  CounterChanged(this.count);
}
