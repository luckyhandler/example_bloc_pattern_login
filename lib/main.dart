import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_login/bloc/authentication/authentication_event.dart';
import 'package:flutter_login/bloc/authentication/authentication_state.dart';
import 'package:flutter_login/presentation/home_page.dart';
import 'package:flutter_login/presentation/login_page.dart';
import 'package:flutter_login/presentation/splash_page.dart';
import 'package:flutter_login/presentation/widget/loading_indicator.dart';
import 'package:flutter_login/repository/user_repository.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          } else if (state is AuthenticationAuthenticated) {
            return HomePage();
          } else if (state is AuthenticationLoading) {
            return LoadingIndicator();
          } else {
            return LoginPage(userRepository: userRepository);
          }
        },
      ),
    );
  }
}
