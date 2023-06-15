import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:new_project/model/user.dart';
import 'package:new_project/user/edit_profile_page.dart';

import 'login/chan_password.dart';

class ProfilePage extends StatefulWidget {
  final User? user;

  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final ValueNotifier<User?> userNotifier = ValueNotifier<User?>(
      widget.user);

  void navigateToEditProfile(BuildContext context) async {
    final editedUser = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfilePage(widget.user, userNotifier)),
    );
    // if (editedUser != null) {
    //   user = editedUser;
    // }
  }

  void logout(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: userNotifier,
          builder: (_, valueUser, __) {
            return Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.blue,
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(Uint8List.fromList(widget
                          .user!.image)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${valueUser!.firstname} ${valueUser.lastname}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  valueUser.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.email),
                    title: Text(valueUser.email),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ChangePasswordPage()),
                      );
                    },
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Profile'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      navigateToEditProfile(context);
                    },
                  ),
                ),

                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Text('Log Out'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      logout(context);
                    },
                  ),
                ),
                SizedBox(height: 16),

              ],
            );
          },
        ),
      ),
    );
  }
}
