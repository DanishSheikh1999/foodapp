import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/infra/api/auth_api_contract.dart';
import 'package:auth/src/infra/api/mapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../domain/credential.dart';
import '../../domain/token.dart';

class AuthApi implements IAuthApi {
  final http.Client _client;
  final String baseUrl;
  var header  = {
      "Content-Type":"application/json",
    };
  AuthApi(
    this._client,
    this.baseUrl,
  );

  @override
  Future<Result<String>> signIn(Credential credential) {
    String endpoint = baseUrl + "/auth/signin";
    return _post(endpoint, credential);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    String endpoint = baseUrl + "/auth/signup";
    return _post(endpoint, credential);
  }

  Future<Result<String>> _post(String endpoint, Credential credential) async {
    print(credential.email);
    dynamic response =
        await _client.post(endpoint, body: jsonEncode(Mapper.toJson(credential)),headers:header);
    print(response.statusCode);
  if (response.statusCode != 200) {
    Map map  = jsonDecode(response.body);
    print(transformError(map));
    return Result.error(transformError(map));
  }
    dynamic json = jsonDecode(response.body);

    return json['authToken'] != null
        ? Result.value(jsonEncode(json))
        : Result.error(json["message"]);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    String endpoint = baseUrl + "/auth/signout";
  var header  = {
      "Content-Type":"application/json",
      "Authorization":token.value
    };
    var res =  await _client.post(endpoint,headers: header);
    if(res.statusCode!=200) return Result.value(false);
    return Result.value(true);

  }

  transformError(Map map){
    var contents = map["error"]??map['errors'];
    if(contents is String) return contents;
    var errStr = contents.fold('',(prev,ele)=> prev + ele.values.first + '\n');
    return errStr;
  }
}
