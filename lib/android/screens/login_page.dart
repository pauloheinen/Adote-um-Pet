import 'package:adote_um_pet/android/components/Container/container_theme.dart';
import 'package:adote_um_pet/android/components/button/elevated_button.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/components/textField/textfield_validation.dart';
import 'package:adote_um_pet/android/controllers/tab_controller.dart';
import 'package:adote_um_pet/android/logic/cubit/pets/pet_cubit.dart';
import 'package:adote_um_pet/android/logic/cubit/user/user_cubit.dart';
import 'package:adote_um_pet/android/models/user_entity.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/screens/create_account_page.dart';
import 'package:adote_um_pet/android/services/user_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserCubit userCubit = UserCubit();

  final _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  void initState() {
    _autoLogin();
    super.initState();
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
                      controller: userCubit.mailController,
                      shouldValidate: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                    child: CustomValidateTextField(
                      label: "Senha",
                      controller: userCubit.passwordController,
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
                    title: const Text('Lembrar de mim',
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
                  TextButton(
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    onPressed: () => _createAccount(),
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

    String email = userCubit.mailController.text;
    String password = userCubit.passwordController.text;

    User? user;
    user = await UserService().getUser(email, password);

    if (user == null) {
      Toast.warningToast(context, 'Usuário não encontrado');
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }
}
