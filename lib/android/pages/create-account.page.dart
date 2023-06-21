import 'package:adote_um_pet/android/components/Container/container-theme.dart';
import 'package:adote_um_pet/android/pages/login.page.dart';
import 'package:adote_um_pet/android/prompts/toast.prompt.dart';
import 'package:adote_um_pet/android/service/user.service.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../components/Border/OutlineInputBorder/outline.border.dart';
import '../components/Button/elevated.button.dart';
import '../components/TextField/textfield-validation.dart';
import '../entity/user.entity.dart';
import '../utilities/Navigator/navigator.util.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPaneState();
}

class _CreateAccountPaneState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
      mask: "(##) # ####-####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

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
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('lib/resources/pet-hotel.png'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextFieldWithValidationCustomWidget(
                    label: "Nome",
                    controller: nameController,
                    shouldValidate: true,
                  ),
                  TextFieldWithValidationCustomWidget(
                    label: "Senha",
                    controller: passwordController,
                    shouldValidate: true,
                    obscure: true,
                  ),
                  TextFieldWithValidationCustomWidget(
                    label: "Email",
                    controller: emailController,
                    shouldValidate: true,
                  ),
                  _phoneTextField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButtonCustomWidget(label: "Voltar", _popPane),
                      ElevatedButtonCustomWidget(
                          label: "Criar conta", _createAccount),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _phoneTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: TextFormField(
        style: const TextStyle(color: Colors.black87),
        validator: (value) {
          if (value == null || value.isEmpty || phoneController.text.isEmpty) {
            return 'O campo deve ser preenchido!';
          }
          return null;
        },
        controller: phoneController,
        keyboardType: TextInputType.multiline,
        inputFormatters: [phoneMask],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineCustomBorder.buildCustomBorder(),
          focusedBorder: OutlineCustomBorder.buildCustomBorder(),
          focusedErrorBorder: OutlineCustomBorder.buildCustomBorder(),
          errorBorder: OutlineCustomBorder.buildCustomBorder(),
          errorStyle: const TextStyle(color: Colors.black87),
          label: const Text(
            "Telefone",
            style: TextStyle(color: Colors.black87, fontSize: 20),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  _createAccount() async {
    BuildContext c = context;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String name = nameController.text.trim();
    String password = passwordController.text;
    String email = emailController.text.trim();
    String phone = phoneMask.getUnmaskedText();

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
    NavigatorUtil.pushTo(context, const LoginPage());
  }

  _isEmailValid() {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(emailController.text);
  }

  _backToLogin() {
    // Toast.confirmToast(context, "Usuário criado!");
    setState(() {
      _popPane();
    });

  }
}
