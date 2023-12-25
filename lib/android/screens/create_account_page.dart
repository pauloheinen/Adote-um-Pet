import 'package:adote_um_pet/android/components/button/elevated_button.dart';
import 'package:adote_um_pet/android/components/container/container_theme.dart';
import 'package:adote_um_pet/android/components/textField/textfield_validation.dart';
import 'package:adote_um_pet/android/logic/cubit/user/user_cubit.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatelessWidget {
  final UserCubit userCubit = UserCubit();

  final _formKey = GlobalKey<FormState>();

  CreateAccountPage({super.key});

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
                      controller: userCubit.nameController,
                      shouldValidate: true),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomValidateTextField(
                      label: "Senha",
                      controller: userCubit.passwordController,
                      shouldValidate: true,
                      obscure: true),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: CustomValidateTextField(
                      label: "Email",
                      controller: userCubit.mailController,
                      shouldValidate: true),
                ),
                userCubit.customPhoneTextField,
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: const Text(
                          'Voltar',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CustomElevatedButton(
                        label: 'Criar conta',
                        onClick: () {
                          _createAccount(context);
                        },
                      )
                    ])
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _createAccount(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await userCubit.addUser().then((value) => {
      if (value == true) {Navigator.of(context).pop()}
    });
  }
}
