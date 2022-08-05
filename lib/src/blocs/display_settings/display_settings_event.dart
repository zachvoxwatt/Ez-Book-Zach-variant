part of 'display_settings_bloc.dart';

@immutable
abstract class DisplaySettingsEvent {}

class DisplaySettingsChange extends DisplaySettingsEvent {
  final double fontSize;
  final String fontFamily;

  DisplaySettingsChange({required this.fontSize, required this.fontFamily});
  List<Object?> get props => [fontSize, fontFamily];
}
