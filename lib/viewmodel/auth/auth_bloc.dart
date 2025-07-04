import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/api_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService api;

  AuthBloc(this.api) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await api.login(event.email, event.password, event.role);
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
