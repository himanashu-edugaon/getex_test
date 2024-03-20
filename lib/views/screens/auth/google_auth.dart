import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getex_test/views/screens/home/widgets/bottom_navigation_screen.dart';
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
        title: const Text(""),
      ),
      body: Column(
      //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
             SizedBox(height: MediaQuery.of(context).size.height * 0.25,width: MediaQuery.of(context ).size.width * 0.1,),
              Text("Get Started with calling app",style: TextStyle(fontSize: 20),),

            ],
          ),
         Material(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 140),
                child:
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        icon: Image.asset(
                          'assets/images/google_image.png',
                          width: 30,
                          height: 40,
                        ),
                        label: const Text(
                          "Sign in with google",
                          style: TextStyle(color: Colors.white,fontSize: 23),
                        ),
                        onPressed: () {
                          signInWithGoogle();
                        },
                      ),
                    ],
                  )
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationWidget(),));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google Signing Successful")));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google Signing Failed")));
      print("failed Google Signing");
    }
  }
}
