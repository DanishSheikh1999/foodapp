import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/details.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main(){
  AuthApi sut;
  http.Client client;
  String baseUrl = "http://localhost:3000";
  setUp((){
    client = http.Client();
    sut = AuthApi(client,baseUrl);
  });

  group("signout",(){
    
    test("return true",() async {
      Credential credential = Credential(email: "danish@email.com", type: AuthType.google,name: "Danish");
      var result = await sut.signIn(credential);
      if(result.isValue){
        var details =  new Details.fromJson(result.asValue.value);
        print(details.toString());
      await Future.delayed(Duration(minutes: 1,seconds: 30));
      var sign = await sut.signOut(details.token);
      expect(sign.asValue.value, true);}
      else
        print(result.asError.error);
    });
  });

}