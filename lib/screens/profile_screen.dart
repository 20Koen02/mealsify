import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:mealsify/res/custom_colors.dart';
import 'package:mealsify/services/UserService.dart';

import '../locator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? currentUser = locator.get<UserService>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    EvaIcons.editOutline,
                    size: 35,
                    color: Color(0xFF3a2318),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Material(
                color: Color(0x4d3a2318),
                child: currentUser != null
                    ? Image.network(
                        currentUser.photoURL,
                        height: 120,
                        fit: BoxFit.fitHeight,
                      )
                    : Icon(
                        EvaIcons.personOutline,
                        size: 120,
                        color: Color(0xFF3a2318),
                      ),
              ),
            ),
            SizedBox(height: 25.0),
            Text(
              currentUser?.displayName ?? 'Loading User...',
              style: TextStyle(
                color: Color(0xFF3a2318),
                fontSize: 40,
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              currentUser?.bio ?? '',
              style: TextStyle(
                color: Color(0xFFB8B8B8),
                fontSize: 20,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
