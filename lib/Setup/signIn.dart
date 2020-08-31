//ログイン画面用Widget
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mychat2_app/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //メッセージ表示用
  String infoText = '';
  //入力したメール右アドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text('ようこそ！',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(10.0, 10.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ],
                    )),
              ),
              Container(
                child: Image.network(
                    'https://imgc.eximg.jp/i=https%253A%252F%252Fs.eximg.jp%252Fexnews%252Ffeed%252FExcite%252Fbit%252F2010%252FE1288627393703_1.jpg,zoom=1200,quality=70,type=jpg'),
                padding: EdgeInsets.all(40),
              ),
              //メールアドレスの入力
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please type au email';
                  }
                },
                onSaved: (input) => email = input,
                decoration: InputDecoration(labelText: 'メールアドレス'),
              ),
              //パスワード入力
              TextFormField(
                validator: (input) {
                  if (input.length < 6) {
                    return 'Your password needs to be atleast 6 chaacters';
                  }
                },
                obscureText: true,
                onSaved: (input) => password = input,
                decoration: InputDecoration(labelText: 'パスワード'),
              ),

              Container(
                padding: EdgeInsets.all(8),
                //メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                //ユーザー登録ボタン
                child: RaisedButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    child: Text('ユーザー登録'),
                    onPressed: () {
                      signIn();
                    }),
              ),
              Container(
                  width: double.infinity,
                  //ログインぽたん
                  child: OutlineButton(
                      textColor: Colors.orange,
                      child: Text('ログイン'),
                      onPressed: () {}))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      //firebaseにログイン
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: email, password: password))
            as FirebaseUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
      } catch (e) {
        print(e.massage);
      }
    }
  }
}
