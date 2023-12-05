import 'package:adote_um_pet/android/components/Editor/pet_editor.dart';
import 'package:adote_um_pet/android/entities/user_entity.dart';
import 'package:adote_um_pet/android/pages/chat_page.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/services/pet_file_service.dart';
import 'package:adote_um_pet/android/services/pet_service.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:flutter/material.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

import '../../../entities/pet_file_entity.dart';
import '../../../entities/pet_entity.dart';
import '../../../services/user_service.dart';
import '../../Carousel/infinity_carousel.dart';
import '../../Dialog/confirmation_dialog.dart';

class PetCard extends StatefulWidget {
  final Pet pet;
  final List<PetFile> files;
  bool? editable;
  final VoidCallback? callback;

  PetCard({
    Key? key,
    required this.pet,
    required this.files,
    this.editable = false,
    this.callback,
  }) : super(key: key);

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  String name = "";
  String city = "";
  String info = "";
  String owner = "";
  bool loaded = false;
  User? actualUser;
  User? ownerPet;

  @override
  void initState() {
    super.initState();
    _loadPetInfo();

    _loadActualUser();
  }

  void _loadActualUser() async {
    await Preferences.getUserData().then((user) => actualUser = user);
  }

  void _loadPetInfo() async {
    await _getPetOwner();
    name = widget.pet.name!;
    city = _getCityName();
    info = widget.pet.info!;
    owner = await _getRefOwnerName().whenComplete(() => setState(() {
      loaded = true;
    }));
  }

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
              pet: widget.pet,
              files: widget.files,
              controller: InfinityPageController(),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                child: loaded
                    ? Text(
                  _displayInfo(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
              const Spacer(),
              PopupMenuButton<int>(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                onSelected: (value) {
                  if (value == 1) {
                    _editPet();
                  } else if (value == 2) {
                    _deletePet();
                  } else if (value == 3) {
                    _openChat();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 1,
                    enabled: widget.editable!,
                    child: const Text("Editar", style: TextStyle(fontSize: 12)),
                  ),
                  PopupMenuItem(
                    value: 2,
                    enabled: widget.editable!,
                    child:
                    const Text("Deletar", style: TextStyle(fontSize: 12)),
                  ),
                  PopupMenuItem(
                    value: 3,
                    enabled: (!widget.editable! &&
                        widget.pet.refOwner != actualUser!.id),
                    child: const Text("Abrir chat",
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCityName() {
    return CidadesEstadosIbge().cidadePorIbge(widget.pet.refCity).nome!;
  }

  Future<void> _getPetOwner() async {
    ownerPet = await UserService().getUserById(widget.pet.refOwner);
  }

  Future<String> _getRefOwnerName() async {
    return ownerPet!.name!;
  }

  String _displayInfo() {
    return "Nome: $name\nTutor: $owner\nCidade: $city\nInfo: $info\n";
  }

  void _editPet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetEditor(
            buildContext: context,
            pet: widget.pet,
            creational: false,
            callback: widget.callback),
      ),
    );
  }

  void _deletePet() {
    ConfirmationDialog(
      title: "Confirmar exclusão",
      message: "Deseja deletar o pet: ${widget.pet.name}?",
      onConfirm: () async {
        await PetService().deletePet(widget.pet);
        await PetFileService().deletePetFiles(widget.pet);
        Navigator.of(context).pop();
        Toast.informToast(context, "O pet ${widget.pet.name} foi removido");
        widget.callback!.call();
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    ).show(context);
  }

  void _openChat() async {
    await Preferences.getUserData().then(
          (userFrom) async => {
        await UserService().getUserById(widget.pet.refOwner).then((userTo) => {
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
