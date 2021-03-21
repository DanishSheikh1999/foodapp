import 'package:cubit/cubit.dart';
import 'package:foodapp/models/helper.dart';

class HeaderCubit extends Cubit<Header>{
  HeaderCubit():super(Header("",""));

  update(String title,String imageUrl) => emit(Header(title,imageUrl));
}