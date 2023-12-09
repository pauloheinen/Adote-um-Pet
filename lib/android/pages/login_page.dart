import 'package:adote_um_pet/android/components/Container/container_theme.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/database/database.dart';
import 'package:adote_um_pet/android/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

import '../components/Button/elevated_button.dart';
import '../components/TextField/textfield_validation.dart';
import '../controllers/tab_controller.dart';
import '../entities/user_entity.dart';
import '../preferences/preferences.dart';
import 'create_account_page.dart';

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

    if (kDebugMode)
      {
        await dotenv.load(fileName: "env.env");

        Toast.warningToast(context, dotenv.get("host"));
        Toast.warningToast(context, dotenv.get("port"));
        Toast.warningToast(context, dotenv.get("userName"));
        Toast.warningToast(context, dotenv.get("password"));
        Toast.warningToast(context, dotenv.get("databaseName"));
        Toast.warningToast(context, dotenv.get("secure"));

        MySQLConnection conn = await MySQLConnection.createConnection(
            host: dotenv.get("host"),
            collation: dotenv.get("collation"),
            port: int.parse(dotenv.get("port")),
            userName: dotenv.get("userName"),
            password: dotenv.get("password"),
            databaseName: dotenv.get("databaseName"),
            secure: bool.parse(dotenv.get("secure")));

        Toast.informToast(context, conn.connected.toString());    
      }
    
    else
      {
        await dotenv.load(fileName: "env.env");

        Toast.warningToast(context, "executando produção");

        Toast.informToast(context, String.fromEnvironment("host") );
        Toast.warningToast(context, dotenv.get("host"));
      }
    

    
    return;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String email = emailController.text;
    String password = passwordController.text;

    User? user;
    try {
      user = await UserService().getUser(email, password);
    } on Exception catch (exception) {
      Toast.warningToast(context, "Não foi possível conectar ao serviço");
      return;
    }

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
