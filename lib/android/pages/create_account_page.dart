import 'package:adote_um_pet/android/components/Container/container_theme.dart';
import 'package:adote_um_pet/android/components/TextField/phone_textfield.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/services/user_service.dart';
import 'package:flutter/material.dart';

import '../components/Button/elevated_button.dart';
import '../components/TextField/textfield_validation.dart';
import '../entities/user_entity.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPaneState();
}

class _CreateAccountPaneState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CustomPhoneTextField phoneTextField = CustomPhoneTextField();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ContainerCustomWidget(
          context: context,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(children: [
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('lib/resources/pet-hotel.png')),
                Container(
                    alignment: Alignment.center,
                    child: const Text('Criar conta',
                        style: TextStyle(fontSize: 20))),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomValidateTextField(
                      label: "Nome",
                      controller: nameController,
                      shouldValidate: true),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomValidateTextField(
                      label: "Senha",
                      controller: passwordController,
                      shouldValidate: true,
                      obscure: true),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomValidateTextField(
                      label: "Email",
                      controller: emailController,
                      shouldValidate: true),
                ),
                phoneTextField,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomElevatedButton(label: "Voltar", onClick: _popPane),
                      CustomElevatedButton(
                          label: "Criar conta", onClick: _createAccount)
                    ])
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String name = nameController.text.trim();
    String password = passwordController.text;
    String email = emailController.text.trim();
    String phone = phoneTextField.getUnmaskedText();

    if (!_isEmailValid()) {
      Toast.warningToast(context, "Email inválido");
      return;
    }

    if (await UserService().emailExists(email)) {
      Toast.warningToast(context, "Email já utilizado!");
      return;
    }

    if (await UserService().phoneExists(phone)) {
      Toast.warningToast(context, "Telefone já utilizado!");
      return;
    }

    User user =
    User(name: name, password: password, email: email, phone: phone);

    int? userId = await UserService().addUser(user);

    if (userId != null) {
      _backToLogin();
    }
  }

  _popPane() {
    Navigator.of(context).pop();
  }

  _isEmailValid() {
    return RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*++/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(emailController.text);
  }

  _backToLogin() async {
    Toast.confirmToast(context, "Usuário criado!");
    _popPane();
  }
}
