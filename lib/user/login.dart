import 'package:flutter/material.dart';

class Lgoin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
        elevation: 0.0,
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context);
          }
          )
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Center(
            child: Image(
              image: AssetImage('image/pildservice.png'),
              width: 170.0,
            ),
          ),
          Form(
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.white,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: EdgeInsets.all(40.0),
                    // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                    // SingleChildScrollView으로 감싸 줌
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: 'Enter email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            decoration:
                            InputDecoration(labelText: 'Enter password'),
                            keyboardType: TextInputType.text,
                            obscureText: true, // 비밀번호 안보이도록 하는 것
                          ),
                          SizedBox(height: 40.0,),
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: (){

                                },
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 15.0)),
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: (){

                                },
                                child: Text('회원가입'),
                                ),
                              ),
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }

}