part of 'display_settings_bloc.dart';

@immutable
abstract class DisplaySettingsState {
  final double fontSize;
  final String fontFamily;

  const DisplaySettingsState(
      {required this.fontSize, required this.fontFamily});
  List<Object> get props => [fontSize, fontFamily];
}

class DisplaySettingsInitial extends DisplaySettingsState {
  const DisplaySettingsInitial() : super(fontSize: 16, fontFamily: 'Roboto');
}

class DisplaySettingsAltered extends DisplaySettingsState {
  const DisplaySettingsAltered({required fontSize, required fontFamily})
      : super(fontSize: fontSize, fontFamily: fontFamily);
}
