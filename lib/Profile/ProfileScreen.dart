import '../NetworkHandler.dart';
import '../Profile/CreatProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  Widget page = CircularProgressIndicator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(child: CircularProgressIndicator());
    //     });
    // var response = await networkHandler.get("/api/v1/profile/");
    // print(response["data"]);
    // print(response["data"]['id']);
    if (

// response.statusCode == 200
        200 != 200) {
      setState(() {
        // page = MainProfile();
        // Navigator.of(context).pop();
      });
    } else {
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      body: Center(child: page),
    );
  }

  Widget showProfile() {
    return Center(child: Text("Profile Data is Avalable"));
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap to Image to add New  Note",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 8, 3, 1),
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatProfile()))
            },
            child: Container(
              height: 60,
              width: 100,

              decoration: BoxDecoration(
image: DecorationImage(
                    alignment: Alignment.center,
                    // matchTextDirection: true,
                    // repeat: ImageRepeat.noRepeat,
                    image: AssetImage("assets/member.jpeg")),
                color: Color.fromARGB(255, 246, 6, 14),
                borderRadius: BorderRadius.circular(20),
              ),
              // child: Center(
              //   child: Text(
              //     "Add New Note",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 18,
              //     ),
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
