import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:fluent_flow/features/login/domain/usecases/resend_email.dart';
// import '../../domain/usecases/forget_password.dart';

import '../../domain/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final Login login;
  
  LoginBloc({required this.login}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if(event is GoLoginEvent) {
        emit(LoginLoadingState());
        //print('loading state emitted --------------------------------------------------');
        var failureOrLogin = await login(
          params: LoginParams(
            email: event.email,
            password: event.password
          )
        );
        await failureOrLogin.fold(
          (failure) async {
            emit(LoginErrorState(message: failure.message));
          },
          (login) async {
            emit(LoginSuccessState());
          } 
        );
      }
      
    });
  }
}
