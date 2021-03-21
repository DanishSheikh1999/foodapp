import '../domain/signup_service_contract.dart';
import 'package:async/async.dart';
import '../domain/token.dart';

class SignInUsecase{
  final ISignUpService iSignUpService;

  SignInUsecase(this.iSignUpService);
  Future<Result<Token>> execute(String email,String password,String name) async{
    return await iSignUpService.signUp(email, password, name);
  }
}