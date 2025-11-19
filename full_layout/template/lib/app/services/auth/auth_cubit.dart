import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/auth_repository.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/models/auth_session.dart';
import 'package:full_layout_base/app/views/login/forms/login_form.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(const AuthInitial());

  LoginForm form = LoginForm.init();

  AuthSession? session;

  Future<void> login() async {
    String email = form.emailController.text.replaceAll(' ', '');
    String password = form.passwordController.text.replaceAll(' ', '');

    if (email.isEmpty) {
      emit(AuthError('email'));
      return;
    }
    if (password.isEmpty) {
      emit(AuthError('pass'));
      return;
    }

    emit(AuthLoading(true));

    final response = await authRepository.login(email, password);

    emit(AuthLoading(false));

    if (response.isError) {
      return;
    }

    session = response.data;

    emit(AuthSuccess());
  }
}
