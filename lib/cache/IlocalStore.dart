import 'package:auth/auth.dart';

abstract class ILocalStore{
  Future<Token>fetch();
  delete(Token token);
  save(Token token);
  saveAuthType(AuthType type);
  Future<AuthType> fetchAuthType();
}