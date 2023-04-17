import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notable/services/auth_service.dart';

class MainAppbar extends StatelessWidget with PreferredSizeWidget {
  const MainAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //menu icon
            const Icon(
              Icons.menu,
              color: Colors.white70,
            ),

            //search field
            SizedBox(
              width: 170,
              child: Text(
                FirebaseAuth.instance.currentUser!.displayName!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),

            // TextField(
            //   decoration: InputDecoration(
            //     hintText: 'Search your notes',
            //     hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
            //   ),
            //   maxLines: 1,
            // ),

            //views icon and profile pic
            // Icon(Icons.grid_view, color: Colors.white70),
            IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: const Icon(Icons.logout, color: Colors.white70),
            ),

            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('lib/images/girla.jpeg'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75.0);
}
