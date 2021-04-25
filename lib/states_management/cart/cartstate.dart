import 'package:cart/cart.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable{
  const CartState();
}

class Initial extends CartState{
  const Initial();
  @override
  List<Object> get props => [];

}

class Loading extends CartState{
  const Loading();
  @override
  List<Object> get props => [];

}

class CartLoaded extends CartState{
  final List<CartItems> cart;
  const CartLoaded(this.cart);
  @override
  List<Object> get props => [cart];

}

class PushCartSuccess extends CartState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class OrdersLoaded extends CartState{
  final List<CartItems> orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object> get props => [orders];
}
class OrderPlaceSuccess extends CartState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
  
}
class OrderCancelState extends CartState{
  final String message;
  const OrderCancelState(this.message);
  @override
  // TODO: implement props
  List<Object> get props => [message];
  
}

class ErrorState extends CartState{
  final String message;
  const ErrorState(this.message);

  @override
  List<Object> get props =>[message];
}
