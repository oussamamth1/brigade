import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Blog/Blogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  chek() async {
    final user = await _auth.currentUser?.uid;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('posts')
        .doc(user)
        .collection("posts");
  }

  void initState() {
    super.initState();
    chek();
  }

//   Widget buildResult(BuildContext context) {
//     final user = _auth.currentUser?.uid;
//     CollectionReference collectionReference = FirebaseFirestore.instance
//         .collection('posts')
//         .doc(user)
//         .collection("posts");
//     return StreamBuilder<QuerySnapshot>(
//         stream: collectionReference.snapshots().asBroadcastStream(),
//         builder: (BuildContext context, snapshot) {
//           if (!snapshot.hasData) {
//             return Container(child: CircularProgressIndicator());
//           } else {
//             print(snapshot.data);

//             print("==================================");
//             print(snapshot.data);
//             QuerySnapshot data = snapshot.requireData;
//             return Expanded(
//                 child: ListView.builder(
//                     itemCount: data.size,
//                     itemBuilder: (context, index) {
//                       print(
//                           "$index ===============================================");
//                       Map item = data.docs[index].data() as Map;

//                       return Card(
//                         child: ListTile(
//                           title: Text(item["email"] as String),
//                         ),
//                       );
//                     }));
// // final String name=data.email

//           }
//         });
//   }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser?.uid;
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('posts')
        .doc(user)
        .collection("posts");

    return Scaffold(
        backgroundColor: Color.fromARGB(214, 223, 25, 25),
        body: FutureBuilder(
            future: collectionReference.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("data erre");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(color: Color.fromARGB(216, 7, 0, 0),child: Column(
children: [Text(
                            
                                snapshot.data!.docs[index].get('name') ,     style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize: 20,
                                  color: Colors.white.withOpacity(0.8)),
                            ),

                            SizedBox(
                              height: 10,
                            ),
Text(
                                snapshot.data!.docs[index].get('phone') as String ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                        SizedBox(
                          height: 10,
                        ),
Text(
                                
                                snapshot.data!.docs[index].get('location') as String ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
Text(
                            
                                snapshot.data!.docs[index].get('dateprice') as String ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
],));
                  },
                );
              }
            }));
  }
}
