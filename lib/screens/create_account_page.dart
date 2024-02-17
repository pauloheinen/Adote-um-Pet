import 'package:adote_um_pet/components/button/elevated_button.dart';
import 'package:adote_um_pet/components/textfield/custom_textfield.dart';
import 'package:adote_um_pet/logic/cubit/textfield/textfield_cubit.dart';
import 'package:adote_um_pet/logic/cubit/user/user_cubit.dart';
import 'package:adote_um_pet/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountPage extends StatelessWidget {
  final UserCubit userCubit = UserCubit();

  final _formKey = GlobalKey<FormState>();

  CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Image.asset('lib/resources/pet-hotel.png')),
                Container(
                    alignment: Alignment.center,
                    child: const Text('Criar conta',
                        style: TextStyle(fontSize: 20))),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: BlocProvider<TextfieldCubit>(
                    create: (context) => TextfieldCubit(),
                    child: CustomTextfield(
                        label: "Nome",
                        controller: userCubit.nameController,
                        shouldValidate: true,
                        textInputType: TextInputType.text),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: BlocProvider<TextfieldCubit>(
                    create: (context) => TextfieldCubit(),
                    child: CustomTextfield(
                        label: "Senha",
                        controller: userCubit.passwordController,
                        shouldValidate: true,
                        obscure: false,
                        textInputType: TextInputType.text),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  child: BlocProvider<TextfieldCubit>(
                    create: (context) => TextfieldCubit(),
                    child: CustomTextfield(
                        label: "Email",
                        controller: userCubit.mailController,
                        shouldValidate: true,
                        textInputType: TextInputType.emailAddress),
                  ),
                ),
                userCubit.customPhoneTextField,
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(218, 89, 253, 163),
                          ),
                        ),
                        onPressed: () {
                          Routes.replaceTo('/loginPage', context);
                        },
                      ),
                      CustomElevatedButton(
                        label: 'Criar conta',
                        onClick: () {
                          _createAccount(context);
                        },
                        buttonSize: ButtonSize.midSize.size,
                      ),
                    ],
                  ),
                ),
              ],
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

    await userCubit.addUser(context).then((value) => {
      if (value == true) {Routes.replaceTo('/loginPage', context)}
    });
  }
}
