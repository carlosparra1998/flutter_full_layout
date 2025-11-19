import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  
  AuthCubit(this.authRepository) : super(const AuthInitial());
}