import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_keeper/ui/home.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PasswordKeeper',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _authorizedOrNot = false;

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to open Application",
        useErrorDialogs: false,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      if (isAuthorized)
        _authorizedOrNot = true;
       else
        _authorizedOrNot = false;

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_authorizedOrNot){
      return;
    }
    else
      _authorizeNow();
  }

  @override
  Widget build(BuildContext context) {
    var router = MaterialPageRoute(builder: (context)=>Home());
    if(!_authorizedOrNot) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Password Keeper"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Icon(Icons.lock, size: 60,),
            ),
            RaisedButton(
              onPressed: _authorizeNow,
              child: Text("Authenticate"),
            )
          ],
        ),
      );
    }
    else
      return MaterialApp(
        title: "passwordkeeper",
        debugShowCheckedModeBanner: false,
        home: Home(),
      );
  }
}
