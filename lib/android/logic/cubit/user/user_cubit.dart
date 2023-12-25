import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/components/textfield/phone_textfield.dart';
import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/services/user_service.dart';
import 'package:adote_um_pet/android/utilities/global.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part "user_states.dart";

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitial());

  final UserService userService = UserService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final CustomPhoneTextField _phoneTextField = CustomPhoneTextField();
  final TextEditingController _mailController = TextEditingController();

  User? _user;

  TextEditingController get nameController => _nameController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get phoneController => _phoneTextField.controller;

  TextEditingController get mailController => _mailController;

  CustomPhoneTextField get customPhoneTextField => _phoneTextField;

  User? get user => _user;

  Future<void> getUser() async {
    emit(UserLoading());

    try {
      _user = await Preferences.getUserData();

      _nameController.text = _user!.name;
      _phoneTextField.controller.text = _user!.phone;
      _mailController.text = _user!.email;
      _passwordController.text = _user!.password;

      emit(UserSuccess(_user!));
    } catch (e) {
      emit(UserError('Ocorreu um erro ao carregar os dados do Usuário!'));
    }
  }

  Future<bool> addUser() async {
    try {
      String name = nameController.text.trim();
      String password = passwordController.text;
      String email = mailController.text.trim();
      String phone = customPhoneTextField.getUnmaskedText();

      if (!_isEmailValid()) {
        Toast.warningToast(snackbarKey.currentContext!, "Email inválido");
        return false;
      }

      if (await UserService().emailExists(email)) {
        Toast.warningToast(snackbarKey.currentContext!, "Email já utilizado!");
        return false;
      }

      if (await UserService().phoneExists(phone)) {
        Toast.warningToast(
            snackbarKey.currentContext!, "Telefone já utilizado!");
        return false;
      }

      User user =
      User(name: name, password: password, email: email, phone: phone);

      int? userId = await userService.addUser(user);

      if (userId == null) {
        return false;
      }

      Toast.successToast(snackbarKey.currentContext!, "Usuário criado!");
      return true;
    } catch (error) {
      Toast.errorToast(
          snackbarKey.currentContext!, 'Não foi possível adicionar o Usuário');
    }

    return false;
  }

  Future<bool> updateUser() async {
    User userLogged = await Preferences.getUserData();

    User user = User(
        id: userLogged.id,
        name: _nameController.text,
        password: _passwordController.text,
        email: _mailController.text,
        phone: _phoneTextField.controller.text);

    bool updatedProfile = await userService.updateUser(user);

    if (!updatedProfile) {
      return false;
    }

    Preferences.saveUserData(user);
    return true;
  }

  _isEmailValid() {
    return RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*++/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(mailController.text);
  }
}
