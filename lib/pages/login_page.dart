import 'package:channelhub/pages/sign_up_page.dart';
import 'package:channelhub/provider/auth_provider.dart';
import 'package:channelhub/screens/home_screen.dart';
import 'package:channelhub/utils/utils.dart';
import 'package:channelhub/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formField = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) => StreamBuilder<auth.User?>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return const Homescreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text(''),
                leading: Container(),
              ),
              backgroundColor: Colors.white,
              body: Form(
                key: _formField,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 260,
                          height: 100,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 30),
                          child: Text(
                            'LOG IN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: CustomTextField(
                            controller: userNameController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Enter Username or email:',
                            hintStyle: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            textAlign: TextAlign.left,
                            enableBorder: true,
                            textStyle: const TextStyle(color: Colors.black),
                            // readOnly: true,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: CustomTextField(
                            isPassword: passToggle,
                            controller: passwordController,
                            hintText: 'Enter Password:',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                            enableBorder: true,
                            textStyle: const TextStyle(color: Colors.black),
                            suffixWidget: InkWell(
                              onTap: () {
                                setState(() {
                                  passToggle = !passToggle;
                                });
                              },
                              child: Icon(
                                passToggle
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(
                                const Size(80, 40),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              alignment: Alignment.center),
                          onPressed: () async {
                            if (userNameController.text.isEmpty) {
                              Utils.showToast('Enter valid email');
                            } else if (passwordController.text.isEmpty) {
                              Utils.showToast('Enter valid password');
                            } else {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              EasyLoading.show();
                              final res =
                                  await authProvider.signInWithEmailAndPassword(
                                userNameController.text,
                                passwordController.text,
                              );
                              EasyLoading.dismiss();
                              if (res.user != null) {
                                userNameController.clear();
                                passwordController.clear();
                                // ignore: use_build_context_synchronously
                                Utils.navigateTo(context, const Homescreen());
                              }
                            }
                          },
                          child: const Text('LOG IN',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.all(const Size(80, 40)),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              alignment: Alignment.center),
                          onPressed: () {
                            Utils.navigateTo(context, const SignupPage());
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
}
