import 'package:flutter/material.dart';
import 'package:todo_list/models/tasks.dart';
import 'package:todo_list/services/sqlite_service.dart';

import '../services/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

FirebaseAuthService firebaseAuthService = FirebaseAuthService();

SQLiteService sqLiteService = SQLiteService();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Add login logic here
                firebaseAuthService.signInWithEmailAndPassword(
                    "janilson.coimbra@gmail.com", "123456");
                final task = Tasks(
                    id: 1,
                    title: 'Task 1',
                    description: 'Description 1',
                    isDone: false,
                    data: '2022-10-10');
                final task2 = Tasks(
                    id: 2,
                    title: 'Task 2',
                    description: 'Description 1',
                    isDone: false,
                    data: '2022-10-10');
                sqLiteService.insertTask(task);
                sqLiteService.insertTask(task2);
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add sign up logic here
                print(firebaseAuthService.currentUser);
              },
              child: const Text('Current User'),
            ),
            ElevatedButton(
              onPressed: () {
                firebaseAuthService.signOut();
              },
              child: const Text('Sign out'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add sign up logic here
                print(sqLiteService
                    .tasks()
                    .then((value) => print(value.toString())));
              },
              child: const Text('List Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
