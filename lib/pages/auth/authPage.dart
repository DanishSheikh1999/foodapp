import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:foodapp/models/users.dart';
import 'package:foodapp/customBuilds/customtextformfield.dart';
import 'package:foodapp/states_management/auth/auth_state.dart';
import 'package:foodapp/states_management/auth/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  final AuthManger authManger;
  final ISignUpService signUpService;

  const AuthPage( {Key key, this.authManger, this.signUpService}) : super(key: key);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String email="";

  String password="";

  String name="";

  int hex(String color) {
    return int.parse("FF" + color.toUpperCase(), radix: 16);
  }

  PageController _controller = PageController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(hex("FF121212")),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: _showLogo(context),
          ),
          SizedBox(height: 50),
          CubitConsumer<AuthCubit,AuthState>(builder:(_,state){
            return _buildUI(context);
          },
          listener: (context,state){

            if(state is LoadingState){
              _showLoader();
            }
            else{
              _hideLoader();
            if(state is ErrorState){
              
              print("ErrorState");
              print(state.error);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 backgroundColor:Theme.of(context).accentColor ,
                content: Text(
                  state.error,
                  style:Theme.of(context).textTheme.caption.copyWith(color:Colors.white,fontSize:16),
                ),

              ));
            }}
            
          },)
          
        ],
      ),
    )));
  }

_showLoader(){
  print("Loader Called");
  var  alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child:CircularProgressIndicator(backgroundColor:Theme.of(context).accentColor ,)
    ),
  );

  showDialog(
    context:context,barrierDismissible:true,builder:(_)=>alert);

}

_hideLoader(){
  Navigator.of(context,rootNavigator: true).pop();
}
  _showLogo(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Image(
                image: AssetImage("assets/logo.png"),
                width: 300,
                height: 200,
                fit: BoxFit.fill),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: "Food",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.lightGreen[500],
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " Mania",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )
                  ]),
            ),
            SizedBox(height:50)
          ],
        ),
      );

  _buildUI(BuildContext context) => Expanded(
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [_signIn(context),_signUp(context)],
        ),
      );

  _signIn(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formkey,
          child: Column(children: [..._emailandpassword(context),
           SizedBox(height:10),
        Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
                onPressed: () {

                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ))),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          onPressed: () async {
            if (_formkey.currentState.validate()) {
              CubitProvider.of<AuthCubit>(context).signin(widget.authManger.email(email, password));
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.all(0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            decoration: ShapeDecoration(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.grey[900], fontSize: 20),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text("-or-",
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 16)),
        SizedBox(height:20),
        IconButton(icon:Image.asset("assets/Google_logo.png"),
        onPressed:(){
          try{
             print("inside");
              CubitProvider.of<AuthCubit>(context).signin(widget.authManger.google);
           }
           catch(error)
            {
              print(error);
            }
        }

        ),
        SizedBox(height: 20,),
        RichText(
          text:TextSpan(
            text:"Don't have a account?",
            style:Theme.of(context).textTheme.caption.copyWith(
              color:Colors.lightGreen[500],
              fontWeight: FontWeight.normal,
              fontSize: 18
            ),
            children: [
              TextSpan(
            text:" Sign Up",
            style:TextStyle(
              color:Theme.of(context).accentColor
            ),
            recognizer: TapGestureRecognizer()..onTap=(){
                  _controller.nextPage(
                    duration:Duration(microseconds: 1000),
                    curve:Curves.elasticIn
                  );
            })
            ]
          )
        )]),
        ),
      );

_signUp(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formkey,
          child: Column(children: [
            CustomTextFormField(
            hint: "Enter Username",
            obscureText: false,
            keyboardType: TextInputType.text,
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.email, color: Theme.of(context).accentColor),
            width: MediaQuery.of(context).size.width / 1.5,
            backgroundColor: Colors.grey[900],
            onChanged: (value) {
              name=value;
            },
            validator: (name)=>name.isEmpty?"Please enter a username":null),
            SizedBox(height:20),
            ..._emailandpassword(context), SizedBox(height:10),
        Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
                onPressed: () {

                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ))),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          onPressed: () async {
            if (_formkey.currentState.validate()) {
              final user = User(email: email,password: password,name: name);
              CubitProvider.of<AuthCubit>(context).signup(widget.signUpService, user);
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.all(0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            decoration: ShapeDecoration(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.grey[900], fontSize: 20),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text("-or-",
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 16)),
        SizedBox(height:20),
        IconButton(icon:Image.asset("assets/Google_logo.png"),
        onPressed:(){
           try{
             print("inside");
              CubitProvider.of<AuthCubit>(context).signin(widget.authManger.google);
           }
           catch(error)
            {
              print(error);
            }
        }

        ),
        SizedBox(height: 20,),
        RichText(
          text:TextSpan(
            text:"Already  have an account?",
            style:Theme.of(context).textTheme.caption.copyWith(
              color:Colors.lightGreen[500],
              fontWeight: FontWeight.normal,
              fontSize: 18
            ),
            children: [
              TextSpan(
            text:" Sign In",
            style:TextStyle(
              color:Theme.of(context).accentColor
            ),
            recognizer: TapGestureRecognizer()..onTap=(){
_controller.previousPage(
                    duration:Duration(microseconds: 1000),
                    curve:Curves.elasticIn
                  );
            })
            ]
          )
        )]),
        ),
      );

  List<Widget> _emailandpassword(BuildContext context) => [
        CustomTextFormField(
            hint: "Enter Email",
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.email, color: Theme.of(context).accentColor),
            width: MediaQuery.of(context).size.width / 1.5,
            backgroundColor: Colors.grey[900],
            onChanged: (value) {
              email=value;
            },
            validator: (email)=>email.isEmpty?"Please Enter an Email":null),
        SizedBox(height: 20),
        CustomTextFormField(
            hint: "Enter Password",
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.lock, color: Theme.of(context).accentColor),
            width: MediaQuery.of(context).size.width / 1.5,
            backgroundColor: Colors.grey[900],
            onChanged: (value) {
             password = value;
            },
            validator: (password) =>password.length<6?"Please enter a password\n of length > 6":null),
           
      ];
}
