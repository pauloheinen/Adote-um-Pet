import 'package:adote_um_pet/android/components/Button/elevated_button.dart';
import 'package:adote_um_pet/android/components/Container/container_theme.dart';
import 'package:adote_um_pet/android/components/Loading/loading_box.dart';
import 'package:adote_um_pet/android/components/TextField/textfield.dart';
import 'package:adote_um_pet/android/components/TextField/textfield_validation.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/components/rounded_photo/user_photo.dart';
import 'package:adote_um_pet/android/logic/cubit/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserCubit userCubit = UserCubit();

  bool _editMode = false;

  @override
  void initState() {
    userCubit.getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserCubit, UserStates>(
        bloc: userCubit,
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CustomLoadingBox(),
            );
          } else if (state is UserSuccess) {
            return profileWidget();
          } else {
            return const Center(child: Text("Erro ao carregar o usuário"));
          }
        },
      ),
    );
  }

  Widget profileWidget() {
    return ContainerCustomWidget(
      context: context,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            CustomUserPhoto(
              user: userCubit.user!,
              editMode: _editMode,
              photoSize: CustomUserPhoto.profileSize,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
              child: CustomTextField(
                  label: "Nome",
                  controller: userCubit.nameController,
                  readOnly: !_editMode),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
              child: CustomValidateTextField(
                  label: "Senha",
                  controller: userCubit.passwordController,
                  shouldValidate: true,
                  obscure: true,
                  readOnly: true),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
              child: CustomTextField(
                  label: "Telefone",
                  controller: userCubit.phoneController,
                  readOnly: !_editMode),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
              child: CustomTextField(
                  label: "Email",
                  controller: userCubit.mailController,
                  readOnly: !_editMode),
            ),
            Visibility(
              visible: !_editMode,
              child: ElevatedButton(
                child: const Text("Editar"),
                onPressed: () => setState(() => _editMode = !_editMode),
              ),
            ),
            Visibility(
              visible: _editMode,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      await userCubit.getUser();
                      _editMode = !_editMode;
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                  CustomElevatedButton(
                    label: "Salvar",
                    onClick: () {
                      _updateProfile();
                      _editMode = !_editMode;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    await userCubit.updateUser().then(
          (value) {
        if (value == true) {
          Toast.successToast(context, "Usuário atualizado!");
        } else {
          Toast.errorToast(context, "Não foi possível atualizar o Usuário");
        }
      },
    );
  }
}
