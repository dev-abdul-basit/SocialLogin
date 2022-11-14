import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/helper/global_config.dart';
import 'package:socaillogin/helper/keyboard.dart';
import 'package:socaillogin/models/user_model.dart';
import 'package:socaillogin/screens/home/homepage.dart';

import 'package:socaillogin/screens/profile/components/profile_header.dart';
import 'package:socaillogin/size_config.dart';

import '../../constants.dart';
import 'dart:async';

class EditProfilePage extends StatefulWidget {
  static String routeName = '/editProfile';
  const EditProfilePage({
    Key? key,
    required this.isEdit,
    required this.route,
  }) : super(key: key);
  final bool isEdit;
  final String route;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController contactctrl = TextEditingController();
  TextEditingController adressctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? contact;
  String? adress;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String imageUrl = 'empty';
  String? fileName;
  //Database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');
  bool isLoading = false;
  final Reference _storageReference =
  FirebaseStorage.instance.ref().child("user_images");
  void uploadImageToFirebase(File file, String fileName) async {
    file.absolute.existsSync();
    //upload
    _storageReference.child(fileName).putFile(file).then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });

    });
  }
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      contactctrl.text = user!.phoneNumber.toString();
    }
      if (box!.get('name') == 'empty') {
        nameCtrl.text = '';
      }else{
        nameCtrl.text = box!.get('name');
      }
    if (box!.get('email') == 'empty') {
      emailctrl.text = '';
    }else{
      emailctrl.text = box!.get('email');
    }
    if (box!.get('address') == 'empty') {
      adressctrl.text = '';
    }else{
      adressctrl.text = box!.get('address');
    }
    if (box!.get('photoUrl') == 'empty') {
     imageUrl = 'empty';
    }else{
     imageUrl = box!.get('photoUrl');
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProfileHeader(
            name: box!.get('name')=='empty'?'':box!.get('name'),
            profileImage:
                 imageUrl == 'empty' ? userImage : imageUrl,
            backPress: () {
              if (widget.route == 'firstLogin') {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomePage.routeName, (route) => false);
              } else {
                Navigator.of(context).pop();
              }
            },
            isVisible: true,
            cameraPress: () {
              _optionsDialogBox();
            },
          ),
          SizedBox(height: getProportionateScreenHeight(120)),
          Expanded(
              child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  children: <Widget>[
                    buildNameFormField(),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    buildEmailFormField(),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    buildContactFormField(),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    buildAdressFormField(),
                    SizedBox(height: getProportionateScreenHeight(28)),
                  ],
                ),
              ),
            ),
          )),
          SizedBox(height: getProportionateScreenHeight(36)),
        ],
      ),
      bottomNavigationBar: Visibility(

        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: PrimaryButton(
            press: () {
              updateProfile();
            },
            text: 'SAVE',
            color: kPrimaryColor,
            textColor: const Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  updateProfile() async {
    if (_formKey.currentState!.validate() &&
        nameCtrl.text.isNotEmpty &&
        contactctrl.text.isNotEmpty &&
        emailctrl.text.isNotEmpty &&
        adressctrl.text.isNotEmpty) {
      _formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);
      UserModel userModel = UserModel.editwithId(
        user!.uid.toString(),
        nameCtrl.text,
        user!.phoneNumber.toString(),
        emailctrl.text,
        adressctrl.text,
        'empty',
        box!.get('status'),
        box!.get('token'),
      );

      await _databaseReference
          .child(user!.uid.toString())
          .update(userModel.toJsonEdit());

      box!.put('name', nameCtrl.text);
      box!.put('email', emailctrl.text);
      box!.put('contact', user!.phoneNumber.toString());
      box!.put('address', adressctrl.text);
      box!.put('status', 'true');
      box!.put('token', box!.get('token'));
      box!.put('photoUrl', 'empty');

      gotoHomeScreen();
    }
  }

  gotoHomeScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => const HomePage())));
  }

  TextFormField buildNameFormField() {
    return TextFormField(

      maxLines: 1,
      controller: nameCtrl,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kNullNameError;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        focusColor: kPrimaryColor,
        hintText: 'Name',
        labelText: 'Name',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        fillColor: kFormColor,
        filled: false,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(

      maxLines: 1,
      controller: emailctrl,
      autocorrect: false,
      cursorColor: kPrimaryColor,
      onSaved: (newValue) => email = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        hintText: 'Email',
        labelText: 'Email',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        filled: false,
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
      ),
    );
  }

  TextFormField buildContactFormField() {
    return TextFormField(
      enabled: false,
      maxLines: 1,
      controller: contactctrl,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => contact = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Contact';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        focusColor: kPrimaryColor,
        hintText: 'Contact',
        labelText: 'Contact',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        fillColor: kFormColor,
        filled: false,
      ),
    );
  }

  TextFormField buildAdressFormField() {
    return TextFormField(

      controller: adressctrl,
      autocorrect: false,
      maxLines: 3,
      cursorColor: kPrimaryColor,
      onSaved: (newValue) => adress = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Adress';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        hintText: 'Address',
        labelText: 'Address',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        filled: false,
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
      ),
    );
  }

  //Camera Method
  Future openCamera() async {
    Navigator.of(context).pop();
    var imageFrmCamera = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50,maxHeight: 120,maxWidth: 120,);
    setState(() {
      _selectedImage = File(imageFrmCamera!.path);
      fileName = _selectedImage!.path.split('/').last;
      uploadImageToFirebase(_selectedImage!,fileName!);
    });
  }

  //Gallery method
  Future openGallery() async {
    Navigator.of(context).pop();
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50,maxHeight: 120,maxWidth: 120,);
    setState(() {
      _selectedImage = File(pickedFile!.path);
      fileName = _selectedImage!.path.split('/').last;
      uploadImageToFirebase(_selectedImage!,fileName!);
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Your Method'),
          backgroundColor: kFormColor,
          contentPadding: const EdgeInsets.all(20.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: openCamera,
                  child:  const Text("Take a Picture"),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                const Divider(
                  color: Colors.white70,
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  onTap: openGallery,
                  child:const  Text("Open Gallery"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
