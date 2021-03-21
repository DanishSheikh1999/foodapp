import 'package:auth/src/domain/auth_service_contract.dart';
import 'package:auth/src/infra/adapters/email_auth.dart';
import 'package:auth/src/infra/adapters/google_auth.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';
import 'package:flutter/foundation.dart';

class AuthManger{
  final IAuthApi iAuthApi;

  AuthManger(this.iAuthApi);
   IAuthService get google => GoogleAuth(iAuthApi);

   IAuthService email(@required String email,@required String password){
     final emailAuth = EmailAuth(iAuthApi);
     emailAuth.credential(email: email, password: password);
     return emailAuth;
   }
}