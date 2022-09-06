import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'time_picker_event.dart';
part 'time_picker_state.dart';

class ReminderTimePickerBloc
    extends Bloc<ReminderTimePickerEvent, ReminderTimePickerState> {
  ReminderTimePickerBloc() : super(ReminderTimePickerInitial()) {
    on<ReminderTimePickerSelectEvent>(_onSelect);
    on<ReminderTimePickerResetEvent>(_onReset);
    on<ReminderTimePickerCancelEvent>(_onCancel);
  }

  void _onSelect(ReminderTimePickerSelectEvent event,
      Emitter<ReminderTimePickerState> emit) async {
    emit(ReminderTimePickerSelected(time: event.time));
  }

  void _onReset(ReminderTimePickerResetEvent event,
      Emitter<ReminderTimePickerState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(ReminderTimePickerInitial());
  }

  void _onCancel(ReminderTimePickerCancelEvent event,
      Emitter<ReminderTimePickerState> emit) {
    emit(ReminderTimePickerCanceled());
  }
}
