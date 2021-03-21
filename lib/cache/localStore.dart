import 'package:auth/src/domain/token.dart';
import 'package:foodapp/cache/IlocalStore.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String token_key = "CACHED_TOKEN";
class LocalStore implements ILocalStore{
  final SharedPreferences sharedPreferences;

  LocalStore(this.sharedPreferences);

  @override
  delete(Token token) {
      this.sharedPreferences.remove(token_key);
    }
  
    @override
    Future<Token> fetch() {
      String token_string = this.sharedPreferences.getString(token_key);
      if(token_string!=null) return Future.value(Token(token_string));

      return null;
    }
  
    @override
   Future save(Token token) {
      return this.sharedPreferences.setString(token_key, token.value);

  }

}