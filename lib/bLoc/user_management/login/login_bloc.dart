import 'dart:async';

import 'package:login_bloc/bLoc/user_management/auth/authentication_bloc.dart';
import 'package:login_bloc/bLoc/user_management/auth/authentication_event.dart';
import 'package:login_bloc/bLoc/user_management/login/login_event.dart';
import 'package:login_bloc/bLoc/user_management/login/login_state.dart';
import 'package:login_bloc/bLoc/user_management/repository/user_repo.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginState currentState,
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
