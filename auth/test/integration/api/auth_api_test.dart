import 'package:auth/src/domain/credential.dart';
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
      Token token = Token(result.asValue.value);
      
      await Future.delayed(Duration(minutes: 1,seconds: 30));
      var sign = await sut.signOut(token);
      expect(sign.asValue.value, true);
    });
  });

}