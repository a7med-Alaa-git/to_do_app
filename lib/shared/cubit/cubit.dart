import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

}