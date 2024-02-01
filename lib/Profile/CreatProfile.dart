import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../HomePage.dart';
import '../NetworkHandler.dart';

import '../Screen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as Im;

class CreatProfile extends StatefulWidget {
  CreatProfile({Key? key}) : super(key: key);

  @override
  _CreatProfileState createState() => _CreatProfileState();
}

class _CreatProfileState extends State<CreatProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  File _imgf = File("");
  PickedFile pickedFile = PickedFile("");
  ImageProvider imp = FileImage(File(""));
  PickedFile _imageFile = PickedFile("");
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _price = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _memberControlle = TextEditingController();
  TextEditingController _phoneControlle = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final postref = FirebaseFirestore.instance.collection('posts');
  final imgepostref = FirebaseFirestore.instance.collection('imgepost');
  final DateTime timeles = DateTime.now();
  final firebaseStorage = FirebaseStorage.instance.ref();
  bool uploading = false;
// late var user =  _auth.currentUser;
  var postid = Uuid().v1();
  Future<String> postData(imageFile) async {
    print("******************** ${timeles}");
    final user = await _auth.currentUser;
    UploadTask uploadTask =
        firebaseStorage.child("post_$postid.jpg").putFile(imageFile);
    TaskSnapshot f = await uploadTask.timeout(Duration(seconds: 50));
    TaskSnapshot taskSnapshot = await uploadTask.timeout(Duration(seconds: 20));
    String Iurl = (await taskSnapshot.ref.getDownloadURL()).toString();
    // TaskSnapshot test = await uploadTask.on.then((onValue) async {
    //       _mainurl = (await _firebaseStorageRef.getDownloadURL()).toString();
    //     });
    //   } catch (error) {
    //     print(error);
    //   }
// firebaseStorage.child("post_$postid.jpg").putFile(imageFile);
    postref.doc(user?.uid).collection("posts").doc(postid).set({
      "postid": postid,
      "ownerid": user?.uid,
      "email": user?.email,
      "price": _price.text.trim(),
      "phone": _phoneControlle.text.trim(),
      "name": _name.text.trim(),
      "location": _title.text.trim(),
      "dateprice": timeles.toString(),
      "mediaurl": Iurl,
// "about":_about.text.trim(),
// "_profession": _about.text.trim()
    });
    setState(() {
      uploading = true;
    });
    return Iurl;
    // print(
    //     "hshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhbcccccccccccccccccccc $_priceController");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_imageFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            professionTextField(),
            SizedBox(
              height: 20,
            ),
            Price(),
            SizedBox(
              height: 20,
            ),
            titleTextField(),
            SizedBox(
              height: 20,
            ),
            // aboutTextField(),
            SizedBox(
              height: 20,
            ),
            PhoneTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: uploading
                  ? null
                  : () async {
                      setState(() {
                        circular = true;
                      });
                      if (_globalkey.currentState!.validate()) {
                        await postData(_imgf);
                      }
                      Navigator.of(context).pop();
                      // hendelchosefromGallery();
                      setState(() {
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 222, 7, 7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            )
            //   InkWell(
            //     onTap: () async {
            //       setState(() {
            //         circular = true;
            //       });
            //       if (1) {
            //         Map<String, String> data = {
            //           "name": _name.text,
            //           // "username": _name.text,
            //           "profession": _profession.text,
            //           "DOB": _dob.text,
            //           "titleline": _title.text,
            //           "about": _about.text,
            //         };
            //         var response =
            //             await networkHandler.post("/profile/add", data);
            //         if (response.statusCode == 200 ||
            //             response.statusCode == 201) {
            //           // print('$_imageFile.path image path');
            //           if (_imageFile != null) {
            //             print(_imageFile);
            //             var imageResponse = await networkHandler.patchImage(
            //                 "/profile/add/image", _imageFile.path);
            //             if (imageResponse.statusCode == 200) {
            //               setState(() {
            //                 circular = false;
            //               });
            //               Navigator.of(context).pushAndRemoveUntil(
            //                   MaterialPageRoute(builder: (context) => HomePage()),
            //                   (route) => false);
            //             }
            //           } else {
            //             setState(() {
            //               print(_imageFile.path);
            //               circular = false;
            //             });
            //             Navigator.of(context).pushAndRemoveUntil(
            //                 MaterialPageRoute(builder: (context) => HomePage()),
            //                 (route) => false);
            //           }
            //         }
            //       }
            //     },
            //     child: Center(
            //       child: Container(
            //         width: 200,
            //         height: 50,
            //         decoration: BoxDecoration(
            //           color: Colors.teal,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Center(
            //           child: circular
            //               ? CircularProgressIndicator()
            //               : Text(
            //                   "Submit",
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    // imp != null
    //     ? FileImage(File(_imageFile.path))
    //     : const AssetImage("assets/profile.jpeg");
    return Center(
      child: Stack(children: <Widget>[
        _imageFile.path != '' ? cercuilerAvatat() : cercuilerGalery()
        // CircleAvatar(
        //     radius: 80.0,
        //     backgroundImage: imp != null
        //         ?
        //         // ? const AssetImage("assets/profile.jpeg")
        //         // :
        //         FileImage(File(_imageFile.path))
        //         : null),
        ,
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget cercuilerAvatat() {
    return CircleAvatar(
        radius: 80.0,
        backgroundImage: _imageFile.path != ''
            ?
            // ? const AssetImage("assets/profile.jpeg")
            // :
            FileImage(File(_imageFile.path))
            : null);
  }

  Widget cercuilerGalery() {
    return CircleAvatar(
        radius: 80.0,
        backgroundImage: _imageFile.path == ''
            ? const AssetImage("assets/imb.jpg")
            // :
            // FileImage(File(_imageFile.path))
            : null);
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    // final ImagePicker _picker = ImagePicker();
    // final XFile? image = await _picker.pickImage(source: source
// ImageSource.gallery,

    final File? imagefile = File(pickedFile!.path);
    // final pickedFile = await _picker.getImage(
    //   source: source,
    // );
    final File file = File(pickedFile!.path);
    setState(() {
      _imageFile = pickedFile;
      _imgf = imagefile!;
      // _imgf = file;
// c=Image.file(_imgf);
      imp = FileImage(_imgf);
      print("$imp ùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùùù");
    });
  }

  // Future<void> uploadimage(imageFile) async {
  //   try {
  //     UploadTask uploadTask =
  //         firebaseStorage.child("post_$postid.jpg").putFile(imageFile);
  //     TaskSnapshot f = await uploadTask.timeout(Duration(seconds: 50));
  //     TaskSnapshot taskSnapshot =
  //         await uploadTask.timeout(Duration(seconds: 30));
  //     String Iurl = taskSnapshot.ref.getDownloadURL().toString();
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  // hendelchosefromGallery() async {
  //   final pickedFile = await _picker.getImage(
  //     source: ImageSource.gallery,
  //   );
  //   setState(() {
  //     // this.pickedFile = pickedFile;
  //     String mediaurl = uploadimage(_imageFile) as String;
  //     createpostfirestor(mediaurl);
  //     print(
  //         "$mediaurl ppppppppppppppppppppppppppppppppppppppppppppppppppmmmmmmmmmmmmmmmmmmm");
  //   });
  // }

  createpostfirestor(String mediaurl) async {
    final user = await _auth.currentUser;
    imgepostref.doc(user?.uid).collection("userp").doc(postid).set({
      "postid": postid,
      "ownerid": user?.uid,
      "email": user?.email,
      "mediaurl": mediaurl,
    });
  }

  CompresImage() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    final tempd = await getTemporaryDirectory();
    final path = tempd.path;
    File? imagefile = File(pickedFile!.path);
    Im.Image? imagefilename = Im.decodeImage(imagefile!.readAsBytesSync());
    final ComprestImageFile = File('$path/img_$postid.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imagefilename!, quality: 85));
    setState(() {
      imagefile = ComprestImageFile;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value != null && value.isEmpty) return "Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Member Nae",
        helperText: "Name can't be empty",
        hintText: "Briade",
      ),
    );
  }

  Widget PhoneTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _phoneControlle,
      validator: (value) {
        if (value != null && value.isEmpty) return "Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Phone number",
        helperText: "Name can't be empty",
        hintText: "Dev Stack",
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value != null && value.isEmpty) return "Profession can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Full Stack Developer",
      ),
    );
  }

  Widget Price() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _price,
      validator: (value) {
        if (value != null && value.isEmpty) return "price empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "price",
        // helperText: "Provide DOB on dd/mm/yyyy",
        // hintText: "01/01/2020",
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value == null || value.isEmpty) return "Location Title errer";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.teal,
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.orange,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "location",
        helperText: "It can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }

  // Widget aboutTextField() {
  //   return TextFormField(
  //     controller: _price,
  //     validator: (value) {
  //       if (value != null && value.isEmpty) return "About can't be empty";

  //       return null;
  //     },
  //     maxLines: 4,
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //           borderSide: BorderSide(
  //         color: Colors.teal,
  //       )),
  //       focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //         color: Colors.orange,
  //         width: 2,
  //       )),
  //       labelText: "Amount",
  //       helperText: "Write about yourself",
  //       hintText: "I am Dev Stack",
  //     ),
  //   );
  // }
}
