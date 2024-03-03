import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getex_test/views/screens/home/Buttom_navation.dart';
import 'package:google_sign_in/google_sign_in.dart';



class GoogleAuth extends StatefulWidget {
  const GoogleAuth({super.key});

  @override
  State<GoogleAuth> createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Google Signin"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Material(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton.icon(
                    icon: Image.asset(
                      'assets/images/google_image.png',
                      width: 30,
                      height: 40,
                    ),
                    label: Text(
                      "Sign in with google",
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                    onPressed: () {
                      signInWithGoogle();
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  signInWithGoogle()async{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    UserCredential users = await FirebaseAuth.instance.signInWithCredential(credential);
    print(users.user?.displayName);
    if(users.user != null){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Signing Successful")));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Signing Failed")));
      print("failed Google Signing");
    }
  }
}
