import 'dart:convert';
import 'dart:io';

import 'package:adote_um_pet/android/components/Button/elevated_button.dart';
import 'package:adote_um_pet/android/components/Container/container_theme.dart';
import 'package:adote_um_pet/android/components/Loading/loading_box.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import '../components/rounded_photo/user_photo.dart';
import '../components/TextField/textfield_validation.dart';
import '../components/TextField/textfield.dart';
import '../utilities/password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();

  bool _editMode = false;
  bool _isLoaded = false;

  late User _user;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cellphoneController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  _loadUser() async {
    _user = await Preferences.getUserData();

    _nameController.text = _user.name!;
    _passwordController.text = Password.decrypt(_user.password!);
    _cellphoneController.text = _user.phone!;
    _mailController.text = _user.email!;

    setState(() => _isLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded == false
        ? const CustomLoadingBox()
        : Scaffold(
      body: ContainerCustomWidget(
          context: context,
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(children: [
                CustomUserPhoto(
                  user: _user,
                  editMode: _editMode,
                  photoSize: CustomUserPhoto.profileSize,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomTextField(
                      label: "Nome",
                      controller: _nameController,
                      readOnly: !_editMode),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomValidateTextField(
                      label: "Senha",
                      controller: _passwordController,
                      shouldValidate: true,
                      obscure: true,
                      readOnly: true),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomTextField(
                      label: "Telefone",
                      controller: _cellphoneController,
                      readOnly: !_editMode),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomTextField(
                      label: "Email",
                      controller: _mailController,
                      readOnly: !_editMode),
                ),
                Visibility(
                    visible: !_editMode,
                    child: ElevatedButton(
                        child: const Text("Editar"),
                        onPressed: () =>
                            setState(() => _editMode = !_editMode))),
                Visibility(
                    visible: _editMode,
                    child: Row(children: [
                      const Spacer(),
                      Expanded(
                          child: Center(
                              child: CustomElevatedButton(
                                  label: "Cancelar",
                                  onClick: () {
                                    setState(() {
                                      _cancelUpdateProfile();
                                      _editMode = !_editMode;
                                    });
                                  }))),
                      Expanded(
                          child: Center(
                              child: CustomElevatedButton(
                                  label: "Salvar",
                                  onClick: () {
                                    setState(() {
                                      _updateProfile();
                                      _editMode = !_editMode;
                                    });
                                  }))),
                      const Spacer()
                    ]))
              ]))),
    );
  }

  void _cancelUpdateProfile() async {
    User userLogged = await Preferences.getUserData();

    _nameController.text = userLogged.name!;
    _passwordController.text = userLogged.password!;
    _mailController.text = userLogged.email!;
    _cellphoneController.text = userLogged.phone!;

    setState(() {});
  }

  void _updateProfile() async {
    User userLogged = await Preferences.getUserData();

    User user = User(
        id: userLogged.id,
        name: _nameController.text,
        password: _passwordController.text,
        email: _mailController.text,
        phone: _cellphoneController.text);

    bool updatedProfile = await _userService.updateUser(user);

    if (updatedProfile) {
      Preferences.saveUserData(user);
      Toast.confirmToast(context, "Dados salvos!");
      return;
    } else {
      Toast.informToast(context, "Edição cancelada!");
    }

    initState();
  }

  Future<void> accessGallery() async {
    XFile? recordedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    String path = recordedImage!.path;

    setState(() {
      var encodedFile = base64Encode(File(path).readAsBytesSync());
      // _profileImage = encodedFile;
    });
  }

  Future<void> accessCamera() async {
    XFile? recordedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    String path = recordedImage!.path;
    GallerySaver.saveImage(path);

    setState(() {
      var encodedFile = base64Encode(File(path).readAsBytesSync());
      // _profileImage = encodedFile;
    });
  }
}
