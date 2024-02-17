import 'package:adote_um_pet/components/button/elevated_button.dart';
import 'package:adote_um_pet/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/components/textfield/custom_textfield.dart';
import 'package:adote_um_pet/logic/cubit/textfield/textfield_cubit.dart';
import 'package:adote_um_pet/logic/cubit/user/user_cubit.dart';
import 'package:adote_um_pet/preferences/preferences.dart';
import 'package:adote_um_pet/routes/routes.dart';
import 'package:adote_um_pet/services/user_service.dart';
import 'package:adote_um_pet/utilities/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: FileUtil.getImage('paw-logo.png'),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Entrar',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: BlocProvider<TextfieldCubit>(
                    create: (context) => TextfieldCubit(),
                    child: CustomTextfield(
                      label: "Email",
                      controller: userCubit.mailController,
                      textInputType: TextInputType.text,
                      shouldValidate: true,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: BlocProvider<TextfieldCubit>(
                    create: (context) => TextfieldCubit(),
                    child: CustomTextfield(
                      label: "Senha",
                      controller: userCubit.passwordController,
                      shouldValidate: true,
                      obscure: true,
                      textInputType: TextInputType.text,
                    ),
                  ),
                ),
                CheckboxListTile(
                  side: const BorderSide(color: Colors.black87),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  value: _rememberMe,
                  visualDensity:
                  const VisualDensity(horizontal: 4, vertical: 0),
                  checkColor: Colors.black87,
                  activeColor: Colors.transparent,
                  title: Text('Lembrar de mim',
                      style: Theme.of(context).textTheme.displaySmall),
                  onChanged: (value) {
                    setState(() => _rememberMe = !_rememberMe);
                  },
                ),
                CustomElevatedButton(
                    label: "Login",
                    onClick: _doLogin,
                    buttonSize: ButtonSize.minSize.size),
                TextButton(
                  child: Text(
                    'Criar conta',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  onPressed: () => _moveTo('/createAccount'),
                ),
              ],
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

    await UserService().getUser(email, password).then((user) => {
      if (user != null)
        {
          Preferences.clearUserData(),
          Preferences.saveRememberMe(_rememberMe),
          Preferences.saveUserData(user),
          _moveTo('/homePage'),
        }
      else
        {
          Toast.warningToast(context, 'Usuário não encontrado'),
        }
    });
  }

  void _autoLogin() async {
    bool? autoLogin = await Preferences.isRemember();

    if (autoLogin == true) {
      _moveTo('/homePage');
    }
  }

  void _moveTo(String path) {
    Routes.replaceTo(path, context);
  }
}
