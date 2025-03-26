part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterDoneState extends RegisterState {}

class RegisterErrorState extends RegisterState {

  final String message;
  const RegisterErrorState({required this.message});
  
  @override
  List<Object> get props => [message];
}

