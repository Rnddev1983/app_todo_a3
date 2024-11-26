import 'package:flutter/material.dart';
import 'package:todo_list/services/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

const textStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  height: 1.5,
  fontWeight: FontWeight.w500,
);

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();

  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 80, bottom: 60),
                child: const Image(
                    image: AssetImage('assets/images/my_schedule.png')),
              ),
              Container(
                child: Icon(Icons.person_pin, size: 150, color: Colors.blue),
              ),
              Container(
                padding: const EdgeInsets.all(44),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: textStyle,
                        textAlign: TextAlign.center,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          //validate email
                          if (!value.contains('@')) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Color.fromRGBO(118, 182, 255, 1),
                          filled: true,
                          hintStyle: textStyle,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      TextFormField(
                        style: textStyle,
                        textAlign: TextAlign.center,
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }

                          if (value.length < 6) {
                            return 'Deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(118, 182, 255, 1),
                          filled: true,
                          hintText: 'Senha',
                          hintStyle: textStyle,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      TextFormField(
                        controller: checkPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }

                          if (value.length < 6) {
                            return 'Senha deve ter no mínimo 6 caracteres';
                          }

                          if (value != passwordController.text) {
                            return 'As senhas não são iguais';
                          }
                          return null;
                        },
                        style: textStyle,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Confirmar senha',
                          fillColor: Color.fromRGBO(118, 182, 255, 1),
                          filled: true,
                          hintStyle: textStyle,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(top: 37),
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Preencha os campos corretamente')));
                              return;
                            }
                            firebaseAuthService
                                .createUserWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text)
                                .catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Preencha as informações corretamente')));
                            });
                          },
                          child: const Text('Sign Up'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
