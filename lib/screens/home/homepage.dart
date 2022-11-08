import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:socaillogin/components/custom_btm_bar.dart';

import 'package:socaillogin/enum.dart';
import '../../helper/global_config.dart';
import '../../models/user_model.dart';
import 'components/body.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child('Users');
  var isLoading = false;
  var userData = [];
  List<UserModel> userModel = <UserModel>[];
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if(user != null){
      getCurrentUser();
    }else{
      print('No User Found');
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:isLoading == false ?const Center(child: CircularProgressIndicator()): const Body(),
      bottomNavigationBar:const CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
  Future<void> getCurrentUser() async {
    _databaseReference.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      userData.clear();
      userModel.clear();

      for (var data in snapshot.children) {
        userData.add(data.value);
      }

      setState(() {
        if (snapshot.exists && userData.isNotEmpty) {
          for (int x = 0; x < userData.length; x++) {
            if (userData[x]['id'] == user!.uid.toString())
                 {
              String id = userData[x]['id'].toString();
              String name = userData[x]['userName'];
              String phone = userData[x]['phone'];
              String email = userData[x]['email'];
              String  address = userData[x]['address'];
              String photoUrl = userData[x]['photoUrl'];
              String status = userData[x]['status'];
              String token = userData[x]['token'];
              //Adding data to Hive
              box!.put("name", userData[x]['userName']);
              box!.put("phone", userData[x]['phone']);
              box!.put("email", userData[x]['email']);
              box!.put("address", userData[x]['address']);
              box!.put("photoUrl", userData[x]['photoUrl']);
              box!.put("status", userData[x]['status']);
              box!.put("token", userData[x]['token']);
              userModel.add(UserModel.editwithId(
                id,
                name,
                phone,
                email,
                address,
                photoUrl,
                status,
                token,
              ));
            }
          }
          isLoading = true;
        } else {
          isLoading = false;
        }
      });
    });
  }
}
