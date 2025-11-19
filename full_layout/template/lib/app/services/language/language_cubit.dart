import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const AuthInitial());

  Locale? _locale;

  Locale? get locale => _locale;

  void initProvider() {
    _locale = Locale('es');
  }

  void changeLanguage(Locale newLoc) {
    _locale = newLoc;
    emit(LanguageUpdated());
  }
}
