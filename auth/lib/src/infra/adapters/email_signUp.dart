import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/signup_service_contract.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';

import 'package:async/async.dart';

class SignUpService implements ISignUpService{
  final IAuthApi iAuthApi;

  SignUpService(this.iAuthApi);

   Future<Result<Token>> signUp(String email, String password, String name) async{
    Credential _credential = Credential(email: email,password: password,name: name,type: AuthType.email);
    print(_credential.email + " " + _credential.type.toString());
    dynamic result = await iAuthApi.signUp(_credential);
    if(result.isError) return result.asError;
    else return Result.value(Token(result.asValue.value));
    
  }
}