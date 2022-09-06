import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/reminder.dart';
import '../../../services/repositories/ping.dart';
import '../../../services/repositories/reminder.dart';

part 'reminder_creation_event.dart';
part 'reminder_creation_state.dart';

class ReminderCreationBloc
    extends Bloc<ReminderCreationEvent, ReminderCreationState> {
  ReminderRepository repo;
  ReminderCreationBloc({required this.repo})
      : super(ReminderCreationInitial()) {
    on<ReminderCreationClearEvent>(_onClear);
    on<ReminderCreationAddEvent>(_onAdd);
  }
  void _onAdd(ReminderCreationAddEvent event,
      Emitter<ReminderCreationState> emit) async {
    emit(ReminderCreationWaiting());
    await Future.delayed(const Duration(seconds: 1));

    var hasConnection = await PingRepository.pingServer();
    if (hasConnection) {
      ReminderResult response = await repo.postReminder(event.datagram);
      if (response.isSuccess) {
        emit(ReminderCreationSuccess());
      } else {
        emit(ReminderCreationErrorNoConnection());
      }
    } else {
      emit(ReminderCreationErrorNoConnection());
    }
  }

  void _onClear(ReminderCreationClearEvent event,
      Emitter<ReminderCreationState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(ReminderCreationInitial());
  }
}
