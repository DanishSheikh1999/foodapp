
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/credential.dart';
import '../../domain/credential.dart';
import '../api/auth_api_contract.dart';
import '../../domain/auth_service_contract.dart';
import '../../domain/credential.dart';
import '../../domain/token.dart';
import 'package:async/async.dart';

import '../api/auth_api_contract.dart';

class GoogleAuth implements IAuthService{
  final IAuthApi iAuthApi;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount currentUser;
  GoogleAuth(this.iAuthApi,[GoogleSignIn googleSignIn]):this._googleSignIn=googleSignIn??GoogleSignIn(
    scopes:[
      'email','profiles'
    ]
  );
  @override
  Future<Result<Token>> signIn() async {
    // TODO: implement signIn
    try{
     currentUser = await _googleSignIn.signIn();
     if(currentUser==null)return Result.error("Failed to signin with Google");
    print(currentUser.email);
    Credential credential  = Credential(email: currentUser.email, type: AuthType.google,name:currentUser.displayName);
    dynamic result = await iAuthApi.signIn(credential);
    if(result.isError) return result.asError;
    return Result.value(Token(result.asValue.value));}
     catch(error){
        print("Error" + error.toString());
        return null;
     }
   
  }

  @override
  Future<Result<bool>> signOut(Token token) async{
    var ans = await iAuthApi.signOut(token);
  if(ans.asValue.value) _googleSignIn.disconnect();
  return ans;

  }

  void handleGoogleSignIn() async{
    try{
      currentUser = await _googleSignIn.signIn();
    }catch(error){
    return;
    }
  }



}