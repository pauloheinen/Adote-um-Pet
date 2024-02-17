import 'package:adote_um_pet/components/Loading/loading_box.dart';
import 'package:adote_um_pet/components/button/elevated_button.dart';
import 'package:adote_um_pet/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/components/rounded_photo/user_photo.dart';
import 'package:adote_um_pet/components/textfield/custom_textfield.dart';
import 'package:adote_um_pet/logic/cubit/textfield/textfield_cubit.dart';
import 'package:adote_um_pet/logic/cubit/user/user_cubit.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          CustomUserPhoto(
            user: userCubit.user!,
            editMode: _editMode,
            photoSize: CustomUserPhoto.profileSize,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
            child: BlocProvider<TextfieldCubit>(
              create: (context) => TextfieldCubit(),
              child: CustomTextfield(
                label: "Nome",
                controller: userCubit.nameController,
                readOnly: !_editMode,
                textInputType: TextInputType.text,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
            child: BlocProvider<TextfieldCubit>(
              create: (context) => TextfieldCubit(),
              child: CustomTextfield(
                label: "Senha",
                controller: userCubit.passwordController,
                obscure: true,
                readOnly: true,
                textInputType: TextInputType.text,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
            child: BlocProvider<TextfieldCubit>(
              create: (context) => TextfieldCubit(),
              child: CustomTextfield(
                label: "Telefone",
                controller: userCubit.phoneController,
                readOnly: !_editMode,
                textInputType: TextInputType.phone,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
            child: BlocProvider<TextfieldCubit>(
              create: (context) => TextfieldCubit(),
              child: CustomTextfield(
                label: "Email",
                controller: userCubit.mailController,
                readOnly: !_editMode,
                textInputType: TextInputType.emailAddress,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Visibility(
              visible: !_editMode,
              child: CustomElevatedButton(
                buttonSize: ButtonSize.minSize.size,
                label: "Editar",
                onClick: () => setState(() => _editMode = !_editMode),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Visibility(
              visible: _editMode,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      await userCubit.getUser();
                      _editMode = !_editMode;
                    },
                    child: Text(
                      'Cancelar',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  CustomElevatedButton(
                    label: "Salvar",
                    buttonSize: ButtonSize.minSize.size,
                    onClick: () {
                      _updateProfile();
                      _editMode = !_editMode;
                    },
                  ),
                ],
              ),
            ),
          )
        ],
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
