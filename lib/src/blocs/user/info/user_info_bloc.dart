import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../models/user.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc() : super(UserInfoInitial()) {
    on<UserInfoSetEvent>(_setHandler);
  }

  void _setHandler(UserInfoSetEvent event, Emitter<UserInfoState> emit) {
    emit(UserInfoActive(user: event.user));
  }
}
