// ignore_for_file: depend_on_referenced_packages, avoid_print
import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  final bool logChange = false;
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (logChange) {
      print('State alteration detected. ${bloc.runtimeType} - $change');
    }
  }
}
