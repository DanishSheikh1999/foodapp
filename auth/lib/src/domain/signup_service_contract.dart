import 'package:async/async.dart';
import 'package:auth/src/domain/details.dart';
import './token.dart';

abstract class ISignUpService{
  Future<Result<Details>> signUp(
    String email,
    String password,
    String name
  );
}