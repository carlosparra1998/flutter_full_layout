part of 'language_cubit.dart';

abstract class LanguageState {
  const LanguageState();
}

class AuthInitial extends LanguageState {
  const AuthInitial();
}

class LanguageUpdated extends LanguageState {
  const LanguageUpdated();
}
