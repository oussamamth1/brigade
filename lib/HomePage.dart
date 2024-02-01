// import '../Blog/addBlog.dart';
// import 'dart:html';

// import 'dart:html';

import 'package:brigaderouge/Screen/addnewMomberr.dart';
import 'package:brigaderouge/login_signup.dart';
import 'package:brigaderouge/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Blog/addBlog.dart';

import '../Screen/HomeScreen.dart';
// import '../Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../NetworkHandler.dart';
// import 'package:logger/logger.dart';

// import '../Screen/SettingsPage1.dart';
import 'Profile/ProfileScreen.dart';
import 'mainPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentState = 0;

  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  // final storage = FlutterSecureStorage();
  final _auth = FirebaseAuth.instance;
  NetworkHandler networkHandler = NetworkHandler();
  String username = "";
  String img = "";
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    final user = await _auth.currentUser?.uid;
    // FirebaseFirestore.instance.collection('users').get().then((value) {
    //   value.docs.forEach((element) {
    //     print("===============================================");
    //     print(element.data());
    //     print("===============================================");
    //   });
    // });
    print(user);
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('posts')
        .doc(user)
        .collection("posts");
    await collectionReference.get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
      });
    });

// // var userid=await net
//     var response = await networkHandler.get("/api/v1/profile/");
//     setState(() {
//       print(response["data"]);
//       img = response["data"]['imag'];
//       username = response["data"]["name"];
//       print(username);
//       log.i(username, "the response of username");
//     });
//     if (response["data"] != null) {
//       setState(() {
//         profilePhoto = CircleAvatar(
//           radius: 20,
//           // backgroundImage: NetworkHandler().getImage(img),
//           backgroundColor: Color.fromARGB(197, 225, 216, 225),
//           // foregroundImage: NetworkHandler().getImage(username),
//         );
//       });
//     } else {
//       setState(() {
//         profilePhoto = Container(
//           height: 100,
//           width: 100,
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.circular(50),
//           ),
//         );
//       });
//     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text("@$username"),
                ],
              ),
            ),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: Text("New Story"),
              trailing: Icon(Icons.add),
              onTap: () {
                // Navigator.push(context,
                //     CupertinoPageRoute(builder: (redContext) => HomePage()));
              },
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingsPage1()),
                // );
              },
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: logout,
            ),
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  profilePhoto,
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 234, 8, 31),
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color.fromARGB(255, 234, 8, 31),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => 
// AddBlog()
NewMomber())
);
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color:  Color.fromARGB(255, 234, 8, 31),
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentState == 0
                      ? Colors.white
                      : Color.fromARGB(137, 19, 1, 1),
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1
                      ? Colors.white
                      : Color.fromARGB(137, 18, 0, 0),
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  void logout() async {
    // await storage.delete(key: "access_token");
   await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => mainpage()),
        (route) => false);
   
  }
}
