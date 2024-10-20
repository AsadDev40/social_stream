// ignore_for_file: use_build_context_synchronously

import 'package:channelhub/model/user_model.dart';
import 'package:channelhub/pages/login_page.dart';
import 'package:channelhub/provider/auth_provider.dart';
import 'package:channelhub/provider/file_upload_provider.dart';
import 'package:channelhub/provider/image_picker_provider.dart';
import 'package:channelhub/screens/home_screen.dart';
import 'package:channelhub/utils/utils.dart';
import 'package:channelhub/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class SignupPage extends HookWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final usernameController = useTextEditingController();

    final showPassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(''),
        leading: Container(),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.black)),
                      child: imageProvider.selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imageProvider.selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.black,
                            ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Choose Profile Photo',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            await imageProvider
                                                .pickImageFromCamera();
                                            Utils.back(context);
                                          },
                                          icon: const Icon(
                                            Icons.camera,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                          label: const Text(
                                            'Camera',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        TextButton.icon(
                                            onPressed: () async {
                                              await imageProvider
                                                  .pickImageFromGallery();
                                              Utils.back(context);
                                            },
                                            icon: const Icon(
                                              Icons.image,
                                              color: Colors.black,
                                            ),
                                            label: const Text('Gallery',
                                                style: TextStyle(
                                                    color: Colors.black)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                            size: 30,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: usernameController,
                  hintText: 'Enter Username:',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                  textStyle: const TextStyle(color: Colors.black),
                  //readOnly: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter Email:',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                  textStyle: const TextStyle(color: Colors.black),
                  //readOnly: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CustomTextField(
                  isPassword: showPassword.value,
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
                      showPassword.value = !showPassword.value;
                    },
                    child: Icon(
                        showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size(190, 40)),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    alignment: Alignment.center),
                child: const Text('SIGN UP',
                    style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  if (emailController.text.isEmpty) {
                    Utils.showToast('Enter valid email');
                    return;
                  } else if (passwordController.text.isEmpty) {
                    Utils.showToast('Enter valid password');
                    return;
                  } else if (usernameController.text.isEmpty) {
                    Utils.showToast('Enter valid username');
                    return;
                  } else if (imageProvider.selectedImage == null) {
                    Utils.showToast('Please select an image');
                    return;
                  } else {
                    EasyLoading.show(status: 'loading...');

                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final res = await authProvider.registerWithEmailAndPassword(
                        emailController.text, passwordController.text);
                    debugPrint(
                        'signup_screen at Line 139: $res, ${res.user?.uid}');

                    final imageUploadProvider =
                        Provider.of<FileUploadProvider>(context, listen: false);
                    final imageUrl = await imageUploadProvider.fileUpload(
                        file: imageProvider.selectedImage!,
                        fileName: 'user-image-${res.user?.uid}',
                        folder: 'profileimages');

                    if (imageUrl != null) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .currentuser!
                          .uid;
                    }
                    if (res.user != null) {
                      await authProvider.addUserToFirestore(
                        UserModel(
                          uid: res.user!.uid,
                          email: emailController.text,
                          userName: usernameController.text,
                          profileImage: imageUrl,
                          issubscribed: false,
                        ),
                      );
                    }

                    EasyLoading.dismiss();
                    usernameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    imageProvider.reset();
                    Utils.navigateTo(
                      context,
                      const Homescreen(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size(190, 40)),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    alignment: Alignment.center),
                onPressed: () async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);

                  EasyLoading.show();

                  await authProvider.signInWithGoogle();
                  EasyLoading.dismiss();
                  Utils.navigateTo(
                    context,
                    const Homescreen(),
                  );
                },
                child: const Text('Continue with Google',
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(const Size(190, 40)),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      alignment: Alignment.center),
                  onPressed: () {
                    Utils.navigateTo(context, const LoginPage());
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
