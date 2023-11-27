import 'package:adote_um_pet/android/components/Container/container-theme.dart';
import 'package:adote_um_pet/android/components/prompts/toast.prompt.dart';
import 'package:adote_um_pet/android/services/user.service.dart';
import 'package:flutter/material.dart';

import '../components/Button/elevated.button.dart';
import '../components/TextField/textfield-validation.dart';
import '../controller/tab.controller.dart';
import '../entities/user.entity.dart';
import '../preferences/preferences.dart';
import 'create-account.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

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
                    child: Image.asset('lib/resources/paw-logo.png'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                    child: CustomValidateTextField(
                      label: "Email",
                      controller: emailController,
                      shouldValidate: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                    child: CustomValidateTextField(
                      label: "Senha",
                      controller: passwordController,
                      shouldValidate: true,
                      obscure: true,
                    ),
                  ),
                  CheckboxListTile(
                    side: const BorderSide(color: Colors.black87),
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    value: _rememberMe,
                    checkColor: Colors.black87,
                    activeColor: Colors.transparent,
                    title: const Text("Lembrar de mim",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        textAlign: TextAlign.start),
                    onChanged: (value) {
                      setState(() => _rememberMe = !_rememberMe);
                    },
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child:
                        CustomElevatedButton(label: "Login", onClick: _doLogin),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                        onPressed: () => _createAccount(),
                      ),
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

  _doLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String email = emailController.text;
    String password = passwordController.text;

    User? user = await UserService().getUser(email, password);
    if (user == null) {
      Toast.warningToast(context, "Usuário não encontrado");
      return;
    }

    Preferences.clearUserData();

    Preferences.saveRememberMe(_rememberMe);
    Preferences.saveUserData(user);

    _moveToAdoptPage();
  }

  void _autoLogin() async {
    bool? autoLogin = await Preferences.isRemember();

    if (autoLogin == true) {
      _moveToAdoptPage();
    }
  }

  void _moveToAdoptPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }

  void _createAccount() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreateAccountPage()));
  }
}
