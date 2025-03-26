import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/register.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final Register register;

  RegisterBloc({required this.register}) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async {
      if(event is GoRegisterEvent) {
        emit(RegisterLoadingState());
        var failureOrLogin = await register(
          params: RegisterParams(
            name: event.name,
            job: event.job,
            email: event.email,
            password: event.password
          )
        );
        await failureOrLogin.fold(
          (failure) async {
            emit(RegisterErrorState(message: failure.message));
          },
          (done) async {
            emit(RegisterDoneState());
          } 
        );
      }
    });
  }
}
