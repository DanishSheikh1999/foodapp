import 'package:async/async.dart';
import './token.dart';

abstract class ISignUpService{
  Future<Result<Token>> signUp(
    String email,
    String password,
    String name
  );
}