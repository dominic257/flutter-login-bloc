import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_bloc/bLoc/user_management/auth/auth_state.dart';
import 'package:login_bloc/bLoc/user_management/auth/authentication_bloc.dart';
import 'package:login_bloc/bLoc/user_management/auth/authentication_event.dart';
import 'package:login_bloc/bLoc/user_management/repository/user_repo.dart';
import 'package:login_bloc/screen/home.dart';
import 'package:login_bloc/screen/indicators/loading_indicator.dart';
import 'package:login_bloc/screen/login/login.dart';
import 'package:login_bloc/screen/splash.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository()));
}


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}


class App extends StatefulWidget {

  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) :super(key: key);

  @override
  State<App> createState() => _AppState();

}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;

  UserRepository get userRepository => widget.userRepository;


  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent,  AuthenticationState>(
          bloc: authenticationBloc,
          builder: _builder
        )
      ),
    );
  }

  get _builder => (BuildContext context,AuthenticationState state){

    if (state is AuthenticationUninitialized) {
      return SplashPage();
    }
    if (state is AuthenticationAuthenticated) {
      return HomePage();
    }
    if (state is AuthenticationUnauthenticated) {
      return LoginPage(userRepository: userRepository);
    }
    if (state is AuthenticationLoading) {
      return LoadingIndicator();
    }
  };


}