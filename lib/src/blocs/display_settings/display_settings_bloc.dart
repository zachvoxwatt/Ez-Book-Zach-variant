import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'display_settings_event.dart';
part 'display_settings_state.dart';

class DisplaySettingsBloc
    extends Bloc<DisplaySettingsEvent, DisplaySettingsState> {
  DisplaySettingsBloc() : super(const DisplaySettingsInitial()) {
    on<DisplaySettingsChange>(changeSettings);
  }

  void changeSettings(
      DisplaySettingsChange event, Emitter<DisplaySettingsState> emit) {
    emit(DisplaySettingsAltered(
        fontSize: event.fontSize, fontFamily: event.fontFamily));
  }
}
