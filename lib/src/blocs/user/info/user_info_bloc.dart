import 'package:bloc/bloc.dart';
import 'package:ez_book/src/services/repositories/user.dart';
import 'package:meta/meta.dart';

import '../../../models/user.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UserRepository repo;
  UserInfoBloc({required this.repo}) : super(UserInfoInitial()) {
    on<UserInfoSetEvent>(_setHandler);
    on<UserInfoSignOutEvent>(_signOut);
    on<UserInfoDeleteEvent>(_onDeletion);
    on<UserInfoTransformInitial>(_onTransition);
  }

  void _setHandler(UserInfoSetEvent event, Emitter<UserInfoState> emit) async {
    await Future.delayed(const Duration(microseconds: 50));
    emit(UserInfoActive(user: event.user));
  }

  void _signOut(UserInfoSignOutEvent event, Emitter<UserInfoState> emit) async {
    emit(UserInfoSignOutWaiting());
    await repo.signout(event.requiredInfo);
    await Future.delayed(const Duration(milliseconds: 1250));
    emit(UserInfoPassive());
  }

  void _onDeletion(
      UserInfoDeleteEvent event, Emitter<UserInfoState> emit) async {
    emit(UserInfoDeleteWaiting());
    await Future.delayed(const Duration(milliseconds: 1500));
    var response = await repo.delete(event.requiredInfo);

    if (response) {
      emit(UserInfoDeletePassive());
    } else {
      emit(UserInfoDeleteError());
    }
  }

  void _onTransition(
      UserInfoTransformInitial event, Emitter<UserInfoState> emit) async {
    await Future.delayed(const Duration(seconds: 5));
    emit(UserInfoInitial());
  }
}
