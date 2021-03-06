import 'dart:convert';

import 'package:auth/auth.dart';
import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/domain/token.dart';
import 'package:foodapp/cache/IlocalStore.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String token_key = "CACHED__TOKEN_AND_DATA";

const String auth_key = "CACHED__TYPE";
class LocalStore implements ILocalStore{
  final SharedPreferences sharedPreferences;

  LocalStore(this.sharedPreferences);

  @override
  delete() {
      this.sharedPreferences.remove(token_key);
    }
  
    @override
    Future<Token> fetch() {
      String data = this.sharedPreferences.getString(token_key);
      print(data);
      if(data!=null) return Future.value(Token(Details.fromJson(data).token.value));

      return null;
    }
  
    @override
   Future save(Details details) {
     
      this.sharedPreferences.setString(token_key, jsonEncode(details.toMap()));

  }

  @override
  saveAuthType(AuthType type) {
    return this.sharedPreferences.setString(auth_key,type.toString());
  }

  @override
  Future<AuthType> fetchAuthType() {
     String auth_String = this.sharedPreferences.getString(auth_key);
     print(auth_String);
      if(auth_String!=null)
        return Future.value(AuthType.values.firstWhere((element) => element.toString()==auth_String));
      return null;
  }

}