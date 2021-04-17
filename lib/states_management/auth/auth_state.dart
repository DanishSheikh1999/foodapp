
import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';


abstract class AuthState extends Equatable{}

class IntialState extends AuthState{
  @override
  // TODO: implement props
  List<Object> get props => [];}

  class LoadingState extends AuthState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  }

  class AuthSuccessState extends AuthState{
  final Details details;
  AuthSuccessState(this.details){}
  @override
  // TODO: implement props
  List<Object> get props => [];

  }

  class ErrorState extends AuthState{
  final String error;
  ErrorState(this.error){}
  @override
  // TODO: implement props
  List<Object> get props => [];

  }

  class SignOutSuccesState extends AuthState{
  @override
  // TODO: implement props
  List<Object> get props => [];

  }