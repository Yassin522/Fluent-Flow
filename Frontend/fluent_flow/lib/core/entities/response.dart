import 'package:equatable/equatable.dart';

class Response extends Equatable{

  final Map<String, dynamic>? data;
  final String? message;

  const Response({required this.data, required this.message});

  @override
  List<Object?> get props => [data, message];
}