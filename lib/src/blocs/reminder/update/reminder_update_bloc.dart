import 'package:bloc/bloc.dart';
import 'package:ez_book/src/services/repositories/reminder.dart';
import 'package:meta/meta.dart';

part 'reminder_update_event.dart';
part 'reminder_update_state.dart';

class ReminderUpdateBloc
    extends Bloc<ReminderUpdateEvent, ReminderUpdateState> {
  final ReminderRepository repo;
  ReminderUpdateBloc({required this.repo}) : super(ReminderUpdateInitial()) {
    on<ReminderUpdateCompletionEvent>(_onCompletionMark);
    on<ReminderUpdateIdleEvent>(_onIdle);
    on<ReminderUpdateInfoEvent>(_onEdit);
    on<ReminderUpdateToInitialEvent>(_onAfterEdit);
    on<ReminderUpdateDeleteEvent>(_onDelete);
  }

  void _onCompletionMark(ReminderUpdateCompletionEvent event,
      Emitter<ReminderUpdateState> emit) async {
    await repo.markReminder(event.reminderId, !event.isCompleted);
    emit(ReminderUpdateSuccess(autoRefresh: true));
  }

  void _onIdle(
      ReminderUpdateIdleEvent event, Emitter<ReminderUpdateState> emit) {
    emit(ReminderUpdateInitial());
  }

  void _onEdit(
      ReminderUpdateInfoEvent event, Emitter<ReminderUpdateState> emit) async {
    emit(ReminderUpdateWaiting());

    await Future.delayed(const Duration(seconds: 1));
    await repo.updateReminder(event.requiredInfo, event.datagram);

    emit(ReminderUpdateSuccess(autoRefresh: false));
  }

  void _onAfterEdit(ReminderUpdateToInitialEvent event,
      Emitter<ReminderUpdateState> emit) async {
    await Future.delayed(const Duration(milliseconds: 750));
    emit(ReminderUpdateInitial());
  }

  void _onDelete(ReminderUpdateDeleteEvent event,
      Emitter<ReminderUpdateState> emit) async {
    emit(ReminderUpdateDeleteWaiting());
    await Future.delayed(const Duration(seconds: 1));

    await repo.deleteReminder(event.reminderId);
    emit(ReminderUpdateDeleted());
  }
}
