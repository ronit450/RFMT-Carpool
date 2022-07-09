import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/model/user_model.dart';
import 'package:flutter_application_1/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyDrawer extends StatefulWidget {

  const MyDrawer({Key? key}): super(key:key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // In drawer we use the list view where any data is presented in list form
      child: Container(
        // so we have wrapped it to set the background color
        color: Colors.purple,
        child: ListView(
          padding: EdgeInsets.zero,
          // it takes childern as parameter
          children: [
            DrawerHeader(
              // edge inssets.zero would remove the padding or margins from the corners
              padding: EdgeInsets.zero,
              // user account drawer header takes two mandatory things which are name and email
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                currentAccountPicture: CircleAvatar(
                  radius: 50.0,
                  // backgroundImage: AssetImage("./assets/Images/5.png"),
                ),
                accountName: Text(
                    "${loggedInUser.firstName} ${loggedInUser.secondName}"),
                accountEmail: Text("${loggedInUser.email}"),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, Myroutes.homepage);
              },
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),

            // For profile
            ListTile(
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),

            // for setting
            ListTile(
              leading: Icon(
                CupertinoIcons.settings_solid,
                color: Colors.white,
              ),
              title: Text(
                "Setting",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),

            // History rides
            ListTile(
              leading: Icon(
                CupertinoIcons.time,
                color: Colors.white,
              ),
              title: Text(
                "History",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),

            // About Us icon

            ListTile(
              leading: Icon(
                CupertinoIcons.info_circle_fill,
                color: Colors.white,
              ),
              title: Text(
                "About us",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),

            // Logout button

            ListTile(
              onTap: () {
               logout(context);
              },
              leading: Icon(
                CupertinoIcons.arrow_left_circle_fill,
                color: Colors.white,
              ),
              title: Text(
                "Logout",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    // now we want to add more buttons in it so for that we will use list tile
  }
    // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
