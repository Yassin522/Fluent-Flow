import 'package:equatable/equatable.dart';

class User extends Equatable {

  final int id;
  final String role;
  final String name;
  final String email;
  final String? imageUrl;
  //For promoted users

  const User({
    required this.name, 
    required this.role, 
    required this.id, 
    required this.email, 
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, id, email, role];
}
