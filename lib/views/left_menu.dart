//return a left menu

import 'package:flutter/material.dart';
import 'package:todo_list/configs/routes_config.dart';
import 'package:todo_list/services/firebase_auth.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (navigatorKey?.currentContext != null)
          ? ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: <Widget>[
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                      (FirebaseAuthService().currentUser?.email != null)
                          ? Text(
                              (FirebaseAuthService()
                                  .currentUser!
                                  .email!
                                  .split('@')[0]
                                  .toString()),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            )
                          : Text(
                              'Usuário',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.of(navigatorKey!.currentContext!)
                        .pushNamed('/task');
                  },
                ),
                ListTile(
                  title: const Text('Configurações'),
                  onTap: () {
                    Navigator.of(navigatorKey!.currentContext!)
                        .pushNamed('/Configs');
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    //logout firebase
                    FirebaseAuthService().signOut().whenComplete(() =>
                        Navigator.of(navigatorKey!.currentContext!)
                            .pushNamed('/login'));
                  },
                ),
              ],
            )
          : Container(),
    );
  }
}
