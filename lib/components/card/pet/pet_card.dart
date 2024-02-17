import 'package:adote_um_pet/components/carousel/infinity_carousel.dart';
import 'package:adote_um_pet/components/dialog/confirmation_dialog.dart';
import 'package:adote_um_pet/components/editor/pet_editor.dart';
import 'package:adote_um_pet/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/logic/cubit/pet/pet_cubit.dart';
import 'package:adote_um_pet/models/pet_entity.dart';
import 'package:adote_um_pet/models/pet_file_entity.dart';
import 'package:adote_um_pet/models/user_entity.dart';
import 'package:adote_um_pet/preferences/preferences.dart';
import 'package:adote_um_pet/screens/chat_page.dart';
import 'package:adote_um_pet/services/pet_file_service.dart';
import 'package:adote_um_pet/services/user_service.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final List<PetFile> files;
  final bool editable;
  final User actualUser;

  const PetCard({
    Key? key,
    required this.pet,
    required this.files,
    this.editable = false,
    required this.actualUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.yellow[100],
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
            child: CustomInfinityCarousel(
              pet: pet,
              files: files,
              controller: InfinityPageController(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PetCardInfo(pet: pet),
              _PopupMenu(
                pet: pet,
                editable: editable,
                user: actualUser,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PetCardInfo extends StatelessWidget {
  final Pet pet;

  const _PetCardInfo({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadPetInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("Erro ao carregar as informações do pet");
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
            child: Text(
              _displayInfo(snapshot.data as Map<String, String>),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          );
        }
      },
    );
  }

  Future<Map<String, String>> _loadPetInfo() async {
    String name = pet.name!;
    String city = CidadesEstadosIbge().cidadePorIbge(pet.refCity).nome!;
    String info = pet.info!;
    User? ownerPet = await UserService().getUserById(pet.refOwner);

    return {
      'name': name,
      'city': city,
      'info': info,
      'owner': ownerPet!.name,
    };
  }

  String _displayInfo(Map<String, String> data) {
    return "Nome: ${data['name']}\nTutor: ${data['owner']}\nCidade: ${data['city']}\nInfo: ${data['info']}\n";
  }
}

class _PopupMenu extends StatelessWidget {
  final Pet pet;
  final bool editable;
  final User user;

  const _PopupMenu({
    Key? key,
    required this.pet,
    required this.editable,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black38),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      onSelected: (value) {
        if (value == 1) {
          _editPet(context);
        } else if (value == 2) {
          _deletePet(context, pet);
        } else if (value == 3) {
          _openChat(context, pet);
        }
      },
      itemBuilder: (BuildContext context) => [
        if (pet.refOwner == user.id)
          PopupMenuItem(
            value: 1,
            enabled: editable,
            child: const Text("Editar", style: TextStyle(fontSize: 12)),
          ),
        if (pet.refOwner == user.id)
          PopupMenuItem(
            value: 2,
            enabled: editable,
            child: const Text("Deletar", style: TextStyle(fontSize: 12)),
          ),
        if (pet.refOwner != user.id)
          PopupMenuItem(
            value: 3,
            enabled: editable,
            child: const Text("Abrir chat", style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  void _editPet(BuildContext buildContext) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: buildContext.read<PetCubit>(),
          child: PetEditor(
            buildContext: buildContext,
            pet: pet,
            creational: false,
          ),
        ),
      ),
    ).then((_) => {
      buildContext.read<PetCubit>().getPets()
    } );
  }

  void _deletePet(BuildContext context, Pet pet) {
    ConfirmationDialog(
      title: "Confirmar exclusão",
      message: "Deseja deletar o pet: ${pet.name}?",
      onConfirm: () async {
        await PetFileService().deletePetFiles(pet);
        await context.read<PetCubit>().deletePet(pet: pet);
        Navigator.of(context).pop();
        Toast.informToast(context, "O pet ${pet.name} foi removido");
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    ).show(context);
  }

  void _openChat(BuildContext context, Pet pet) async {
    await Preferences.getUserData().then(
          (userFrom) async => {
        await UserService().getUserById(pet.refOwner).then((userTo) => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                fromUser: userFrom,
                toUser: userTo!,
              ),
            ),
          ),
        })
      },
    );
  }
}
