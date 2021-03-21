import '../domain/auth_service_contract.dart';
import 'package:async/async.dart';
import '../domain/token.dart';

class SignInUsecase{
  final IAuthService iAuthService;

  SignInUsecase(this.iAuthService);
  Future<Result<Token>> execute() async{
    return await iAuthService.signIn();
  }
}