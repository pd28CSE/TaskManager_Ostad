import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/models/auth_utility.dart';
import '../screens/auth_screens/login_screen.dart';
import '../screens/profile_screens/profile_update_screen.dart';

class UserProfileBanner extends StatelessWidget {
  final bool? isInProfileUpdateScreen;
  const UserProfileBanner({
    super.key,
    this.isInProfileUpdateScreen,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: isInProfileUpdateScreen == true
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (cntxt) => const ProfileUpdateScreen(),
                  ),
                );
              },
        child: Row(
          children: <Widget>[
            Visibility(
              visible: isInProfileUpdateScreen == null,
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: AuthUtility.userModel.data!.photo!.isNotEmpty,
                    replacement: const Icon(Icons.person_2_outlined, size: 30),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: MemoryImage(
                        base64Decode(AuthUtility.userModel.data!.photo!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${AuthUtility.userModel.data?.firstName ?? ''} ${AuthUtility.userModel.data?.lastName ?? ''}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AuthUtility.userModel.data?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            await AuthUtility.clearUserInfo();
            Future.delayed(Duration.zero).then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (cntxt) {
                    return const LoginScreen();
                  },
                ),
                (route) => false,
              );
            });
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
