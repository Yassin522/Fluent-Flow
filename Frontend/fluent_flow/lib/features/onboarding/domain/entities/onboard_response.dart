import 'package:equatable/equatable.dart';

class OnBoard extends Equatable{
  final bool firstTime;

  const OnBoard({required this.firstTime});
  
  @override
  List<Object?> get props => [firstTime];
}
