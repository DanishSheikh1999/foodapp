import 'package:async/src/result/result.dart';
import 'package:auth/auth.dart';
import 'package:cubit/cubit.dart';

import '../../cache/IlocalStore.dart';
import '../../models/users.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ILocalStore localStore;
  AuthCubit(
    this.localStore,
  ) : super(IntialState());

  signin(IAuthService iAuthService,AuthType type) async{
    _startLoading();
    final result = await iAuthService.signIn();
    localStore.saveAuthType(type);
    _setResultOfAuthState(result);
      }
    signout(IAuthService iAuthService) async {
      _startLoading();
      final token = await localStore.fetch();
      if(token==null){
          print("Error fetching the token");
          emit(ErrorState("Error fetching the token"));}
      else{
      final result = await iAuthService.signOut(token);
      
      if(result.asValue.value){
        localStore.delete();
        emit(SignOutSuccesState());
      }
      else
        emit(ErrorState("Error signing out"));}
    }

    signup(ISignUpService iSignUpService,User user) async{
        _startLoading();
        final result = await iSignUpService.signUp(user.email, user.password, user.name);
        _setResultOfAuthState(result);
    }
      void _setResultOfAuthState(Result<Details> result) {
        if(result.asError!=null){
          emit(ErrorState(result.asError.error));
          return;}
          localStore.save(result.asValue.value);
        emit(AuthSuccessState(result.asValue.value));
      }

  void _startLoading(){
    emit(LoadingState());
  }
  
}
