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

  signin(IAuthService iAuthService) async{
    _startLoading();
    final result = await iAuthService.signIn();
    _setResultOfAuthState(result);
      }
    signout(IAuthService iAuthService)async{
      _startLoading();
      final token = await localStore.fetch();
      final result = await iAuthService.signOut(token);
      
      if(result.asValue.value){
        localStore.delete(token);
        emit(SignOutSuccesState());
      }
      else
        emit(ErrorState("Error signing out"));
    }

    signup(ISignUpService iSignUpService,User user) async{
        _startLoading();
        final result = await iSignUpService.signUp(user.email, user.password, user.name);
        _setResultOfAuthState(result);
    }
      void _setResultOfAuthState(Result<Token> result) {
        if(result.asError!=null){
          emit(ErrorState(result.asError.error));
          return;}
        emit(AuthSuccessState(result.asValue.value));
      }

  void _startLoading(){
    emit(LoadingState());
  }
  
}
