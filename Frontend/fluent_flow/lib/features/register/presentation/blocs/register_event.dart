part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class GoRegisterEvent extends RegisterEvent {

  final String email;
  final String password;
  final String name;
  final String job;

  const GoRegisterEvent({required this.email, required this.name, required this.password, required this.job});

  @override
  List<Object> get props => [name, email, password, job];
}
