import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/reminder.dart';
import '../../../services/repositories/ping.dart';
import '../../../services/repositories/reminder.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderRepository repo;
  ReminderBloc({required this.repo}) : super(ReminderInitial()) {
    on<ReminderLoadEvent>(_onLoad);
    on<ReminderSilentRefreshEvent>(_onSilentRefresh);
  }

  void _onLoad(ReminderLoadEvent event, Emitter<ReminderState> emit) async {
    emit(ReminderLoading());
    await Future.delayed(const Duration(seconds: 1));
    var hasConnection = await PingRepository.pingServer();
    if (hasConnection) {
      emit(ReminderLoaded(
          reminderList: await repo.getReminders(event.requiredInfo)));
    } else {
      emit(ReminderErrorNoConnection());
    }
  }

  void _onSilentRefresh(
      ReminderSilentRefreshEvent event, Emitter<ReminderState> emit) async {
    var hasConnection = await PingRepository.pingServer();
    if (hasConnection) {
      emit(ReminderLoaded(
          reminderList: await repo.getReminders(event.requiredInfo)));
    } else {
      emit(ReminderErrorNoConnection());
    }
  }
}
