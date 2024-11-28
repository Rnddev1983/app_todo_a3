import 'package:flutter/material.dart';
import 'package:todo_list/commons/validates.dart';
import 'package:todo_list/models/custom_notification.dart';
import 'package:todo_list/services/firebase_auth.dart';
import 'package:todo_list/services/local_notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    firebaseAuthService.authStateChanges.listen((user) {
      if (user != null) {
        Navigator.pushNamed(context, '/task');
      }
    });

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromARGB(255, 175, 219, 255)],
          ),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 60),
                child: const Image(
                    image: AssetImage('assets/images/my_schedule.png')),
              ),
              Container(
                  width: 300,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    border:
                        Border.fromBorderSide(BorderSide(color: Colors.black)),
                    // color: Color.fromARGB(255, 255, 104, 104),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        //child text
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        //input text
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            return Validates.email(value);
                          },
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(0, 175, 219, 255),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Password',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        //input text
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            return Validates.password(value);
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(0, 175, 219, 255),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: 300,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Preencha os campos corretamente')));
                                return;
                              }

                              setState(() {
                                firebaseAuthService
                                    .signInWithEmailAndPassword(
                                        emailController.text,
                                        passwordController.text)
                                    .catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Confira seu email e senha',
                                      ),
                                    ),
                                  );
                                });
                              });
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        Row(
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/sign-up');
                                // CustomNotification notificationService =
                                //     CustomNotification(
                                //         id: 1,
                                //         title: 'Teste',
                                //         body: 'Notificando',
                                //         payload: '/sign-up');
                                // NotificationService()
                                //     .showLocalNotification(notificationService);
                              },
                              child: const Text('Sign up'),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
