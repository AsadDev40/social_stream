// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:channelhub/provider/auth_provider.dart';
import 'package:channelhub/provider/file_upload_provider.dart';
import 'package:channelhub/provider/image_picker_provider.dart';
import 'package:channelhub/screens/profile_screen.dart';
import 'package:channelhub/utils/utils.dart';
import 'package:channelhub/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends HookWidget {
  final String userid;
  final String imagepath;
  final String username;
  final String email;
  const EditProfilePage(
      {super.key,
      required this.imagepath,
      required this.username,
      required this.email,
      required this.userid});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final fileProvider = Provider.of<FileUploadProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final emailController = useTextEditingController(text: email);
    final usernameController = useTextEditingController(text: username);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: imageProvider.selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imageProvider.selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.network(imagepath, fit: BoxFit.cover),
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
                            Icons.edit,
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
                  textStyle: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white)),
                child: const Text('UPDATE PROFILE',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onPressed: () async {
                  EasyLoading.show();
                  String? newImageUrl;
                  if (imageProvider.selectedImage != null) {
                    newImageUrl = await fileProvider.updateFile(
                        file: imageProvider.selectedImage as File,
                        oldImageUrl: imagepath,
                        folder: 'profileimages',
                        name: 'user-image-$userid');
                  }
                  await authProvider.updateUserProfile(usernameController.text,
                      emailController.text, newImageUrl!);
                  EasyLoading.dismiss();
                  Utils.navigateTo(context, const Profilescreen());
                  imageProvider.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
