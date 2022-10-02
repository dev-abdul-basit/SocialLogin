import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socaillogin/components/primary_button.dart';
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
  bool isEnabled = false;
  TextEditingController namectrl = TextEditingController();
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
  String imageUrl = 'Empty';

  String? fileName;

  @override
  void initState() {
    super.initState();

    isEnabled = widget.isEdit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProfileHeader(
            profileImage:
                imageUrl == 'Empty' ? 'assets/images/user.png' : fileName!,
            isEdit: widget.isEdit,
            backPress: () {
              if (widget.route == 'firstLogin') {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomePage.routeName, (route) => false);
              } else {
                Navigator.of(context).pop();
              }
            },
            editPress: () {
              setState(() {
                //isEnabled = !isEnabled;
              });
            },
            cameraPress: () {
              _optionsDialogBox();
            },
            icon: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 36,
            ),
            // icon: isEnabled
            //     ? const Icon(
            //         Icons.done_all_rounded,
            //         color: Colors.white,
            //         size: 36,
            //       )
            //     : const Icon(
            //         Icons.edit_note_rounded,
            //         color: Colors.white,
            //         size: 36,
            //       ),
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
        visible: isEnabled,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: PrimaryButton(
            press: () {},
            text: 'SAVE',
            color: kPrimaryColor,
            textColor: const Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      enabled: isEnabled,
      maxLines: 1,
      controller: namectrl,
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
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        fillColor: kFormColor,
        filled: false,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      enabled: isEnabled,
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
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        filled: false,
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
      ),
    );
  }

  TextFormField buildContactFormField() {
    return TextFormField(
      enabled: isEnabled,
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
        hintText: 'Contact',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        fillColor: kFormColor,
        filled: false,
      ),
    );
  }

  TextFormField buildAdressFormField() {
    return TextFormField(
      enabled: isEnabled,
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
        hintText: 'Adress',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        filled: false,
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
      ),
    );
  }

  //Camera Method
  Future openCamera() async {
    Navigator.of(context).pop();
    var imageFrmCamera = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = File(imageFrmCamera!.path);
      fileName = _selectedImage!.path.split('/').last;
    });
  }

  //Gallery method
  Future openGallery() async {
    Navigator.of(context).pop();
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(pickedFile!.path);
      fileName = _selectedImage!.path.split('/').last;
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
                  child: const Text("Take a Picture"),
                  onTap: openCamera,
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
                  child: const Text("Open Gallery"),
                  onTap: openGallery,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
