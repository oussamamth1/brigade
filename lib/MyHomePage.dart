import 'dart:io';

import 'package:brigaderouge/login_signup.dart';
import 'package:brigaderouge/mainPage.dart';
import 'package:brigaderouge/widgets/image.dart';
import 'package:brigaderouge/widgets/my_widgets.dart';
import 'package:brigaderouge/widgets/newtransaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

var loggedinUser;

// ignore: non_constant_identifier_names
// User Curentuser=new User() ;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _memberControlle = TextEditingController();
  TextEditingController _phoneControlle = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var postid = Uuid().v1();
  imagePickDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Image.asset(
                  'assets/gallary.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  int selectedRadio = 0;

  File? profileImage;
  final postref = FirebaseFirestore.instance.collection('posts');
  final DateTime timeles = DateTime.now();
  getData() async {
    final user = await _auth.currentUser?.uid;
    // FirebaseFirestore.instance.collection('users').get().then((value) {
    //   value.docs.forEach((element) {
    //     print("===============================================");
    //     print(element.data());
    //     print("===============================================");
    //   });
    // });
    print(user);
    DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc(user);
    await doc.get().then((value) {
      print(value.data());
    });
  }

  postData() async {
    final user = await _auth.currentUser;
    postref.doc(user?.uid).collection("posts").doc(postid).set({
      "postid": postid,
      "ownerid": user?.uid,
      "email": user?.email,
      "price": _priceController.text.trim(),
      "phone": _phoneControlle.text.trim(),
    });

   
    print(
        "hshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhbcccccccccccccccccccc $_priceController");
  }

  void initState() {
    super.initState();

    getData();
    postData();

    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      print(user?.uid);
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => LoginView(),
                //     ),
                //     (route) => false);
                // Navigator.pop(context);

                //Implement logout functionality
              }),
        ],
        title: Text('Home Page'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Form(
          child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Blogging",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold)),

                SizedBox(height: 60.0),

                // Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 25.0)),

                //SizedBox(height: 20.0),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _phoneControlle,
                  decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.person, color: Colors.white)),
                  // validator: (val) => val?.isEmpty ? 'This field cannot be blank' : null
                ),

                SizedBox(height: 15.0),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _priceController,
                  decoration: InputDecoration(
                      hintText: 'Valid Email',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon:
                          Icon(Icons.alternate_email, color: Colors.white)),
                  // validator: (val) {
                  //   return RegExp(
                  //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  //           .hasMatch(val)
                  //       ? null
                  //       : "Please enter a valid email";
                  // },
                ),

                SizedBox(height: 15.0),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _memberControlle,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.lock, color: Colors.white)),
                  // validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
                  obscureText: true,
                ),

                SizedBox(height: 15.0),

                // TextFormField(
                //   style: TextStyle(color: Colors.white),
                //   controller: _confirmPasswordEditingController,
                //   decoration: textInputDecoration.copyWith(
                //     hintText: 'Confirm password',
                //     hintStyle: TextStyle(color: Colors.white70),
                //     prefixIcon: Icon(Icons.lock, color: Colors.white),
                //   ),
                //   validator: (val) => val == _passwordEditingController.text ? null : 'Does not macth the password',
                //   obscureText: true,
                // ),

                SizedBox(height: 20.0),

                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                      // elevation: 0.0,
                      // color: Colors.white,
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Sign Up',
                          style: TextStyle(color: Colors.blue, fontSize: 16.0)),
                      onPressed: (() async {
                        await postData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      })),
                ),

                SizedBox(height: 20.0),

                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                            color: Colors.black87,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // await postData();
                            await Future.delayed(Duration(seconds: 1), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen()),
                              );
                            });
                          },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.0),

                // Text(_error,
                //     style: TextStyle(color: Colors.red, fontSize: 14.0)),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
