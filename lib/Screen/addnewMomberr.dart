import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
final _globalkey = GlobalKey<FormState>();
TextEditingController _title = TextEditingController();
TextEditingController _body = TextEditingController();

class NewMomber extends StatefulWidget {
  const NewMomber({super.key});

  @override
  State<NewMomber> createState() => _NewMomberState();
}

class _NewMomberState extends State<NewMomber> {

ImagePicker _picker = ImagePicker();

PickedFile _imageFile = PickedFile("");
  IconData iconphoto = Icons.image;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // if (_imageFile.path != null &&
              //     _globalkey.currentState.validate()) {
              //   showModalBottomSheet(
              //     context: context,
              //     builder: ((builder) => OverlayCard(
              //           imagefile: _imageFile,
              //           title: _title.text,
              //         )),
              //   );
              // }
            },
            child: Text(
              "Preview",
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          )
        ],
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            titleTextField(),
            titleTextField(),
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 20,
            ),
            // addButton(),
          ],
        ),
      ),
    );
  }
  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value!=null&& value.isEmpty) {
            return "Title can't be empty";
          } else if (value != null && value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 171, 4, 4),
              width: 2,
            ),
          ),
          labelText: "Add Image and Title",
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color: Color.fromARGB(255, 2, 21, 231),
            ),
            onPressed:
 takeCoverPhoto,
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 198, 4, 4),
              width: 2,
            ),
          ),
          labelText: "Provide Body Your Blog",
        ),
        maxLines: null,
      ),
    );
  }
void takeCoverPhoto() async {
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto!;
      iconphoto = Icons.check_box;
    });
  }
}