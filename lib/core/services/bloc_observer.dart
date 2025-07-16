import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBlocObserver extends BlocObserver{
  @override
  void onChange(BlocBase bloc, Change change) {
    log('❗👀:: $bloc :: $change');
    super.onChange(bloc, change);
  }
}