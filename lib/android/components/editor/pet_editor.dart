import 'package:adote_um_pet/android/components/Button/elevated_button.dart';
import 'package:adote_um_pet/android/components/Carousel/infinity_carousel.dart';
import 'package:adote_um_pet/android/components/Picker/image_picker.dart';
import 'package:adote_um_pet/android/components/TextField/textfield_validation.dart';
import 'package:adote_um_pet/android/components/TextField/textfield.dart';
import 'package:adote_um_pet/android/models/pet_file_entity.dart';
import 'package:adote_um_pet/android/models/pet_entity.dart';
import 'package:adote_um_pet/android/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/android/services/pet_file_service.dart';
import 'package:adote_um_pet/android/services/pet_service.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:cidades_estados_ibge/models/cidade_model.dart';
import 'package:flutter/material.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

class PetEditor extends StatefulWidget {
  final BuildContext buildContext;
  final Pet pet;
  final bool creational;
  final VoidCallback? callback;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final InfinityPageController pageController = InfinityPageController();

  PetEditor({
    Key? key,
    required this.buildContext,
    required this.pet,
    required this.creational,
    this.callback,
  }) : super(key: key);

  @override
  State<PetEditor> createState() => _PetEditorState();
}

class _PetEditorState extends State<PetEditor> {
  List<PetFile> petFiles = [];
  bool isLoading = true;
  late Pet _originalPet;
  final List<PetFile> _originalPetFiles = [];

  @override
  void initState() {
    super.initState();
    _originalPet = widget.pet;
    _loadPetDataAndFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(color: Colors.yellow[200]),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomInfinityCarousel(
                        pet: widget.pet,
                        files: petFiles,
                        controller: widget.pageController,
                      ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              deleteImage();
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: () {
                              openImageSelector();
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 25, 10),
                child: CustomValidateTextField(
                  label: "Nome",
                  controller: widget.nameController,
                  shouldValidate: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 25, 10),
                child: CustomTextField(
                  label: "Info",
                  controller: widget.infoController,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 25, 10),
                child: CustomTextField(
                  label: "Estado/Cidade",
                  controller: widget.cityController,
                  readOnly: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    label: "Cancelar",
                    onClick: () {
                      _cancelChanges().then((value) => {
                        _callCallback(),
                        _popPane(),
                      });
                    },
                  ),
                  CustomElevatedButton(
                    label: "Confirmar",
                    onClick: () async {
                      await _confirmChanges().then((value) => {
                        _callCallback(),
                        _popPane(),
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadPetDataAndFiles() async {
    await _loadPetData();
    await _loadPetFiles();
    _originalPetFiles.addAll(petFiles);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadPetData() async {
    CidadeModel model = CidadesEstadosIbge().cidadePorIbge(widget.pet.refCity);

    if (widget.pet.name != null && widget.pet.name!.isNotEmpty) {
      widget.nameController.text = widget.pet.name!;
    }

    if (widget.pet.info != null && widget.pet.info!.isNotEmpty) {
      widget.infoController.text = widget.pet.info!;
    }

    widget.cityController.text = "${model.nome!}/${model.siglaUF!}";
  }

  Future<void> _loadPetFiles() async {
    petFiles = await PetFileService().getFilesByPet(widget.pet);
  }

  Future<void> _confirmChanges() async {
    widget.pet.name = widget.nameController.text;
    widget.pet.info = widget.infoController.text;

    await PetService().updatePet(widget.pet);
  }

  Future<void> _cancelChanges() async {
    if (widget.creational) {
      _deletePetAndFiles();
    } else {
      _rollbackPet();

      await _rollbackPetFiles();
    }
  }

  void _deletePetAndFiles() async {
    await PetService().deletePet(widget.pet).then((deleted) => {
      if (deleted)
        {
          PetFileService().deletePetFiles(widget.pet).then((value) =>
              Toast.informToast(widget.buildContext, "Edição cancelada!"))
        }
    });
  }

  Future<void> _rollbackPetFiles() async {
    await PetFileService().deletePetFiles(widget.pet);
    await PetFileService().addFiles(_originalPetFiles).then(
            (value) => Toast.informToast(context, "Dados não foram alterados"));
  }

  void _rollbackPet() {
    widget.pet.copyFrom(_originalPet);
    widget.nameController.text = widget.pet.name!;
    widget.infoController.text = widget.pet.info!;
  }

  void _popPane() {
    Navigator.of(context).pop();
  }

  void deleteImage() {
    if (petFiles.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirma exclusão da foto?"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Não"),
            ),
            TextButton(
              onPressed: () {
                removeImage();
                Navigator.of(context).pop();
              },
              child: const Text("Sim"),
            ),
          ],
        ),
      );
    }
  }

  void removeImage() async {
    PetFile petFile = petFiles[widget.pageController.page];

    await PetFileService().deletePetFile(petFile);
    petFiles.remove(petFile);

    setState(() {});
  }

  void openImageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0),
        content: ImagePickerWidget(
          onSelect: (value) {
            addPetFileAndUpdateState(value.toString());
          },
        ),
      ),
    );
  }

  void addPetFileAndUpdateState(String encoded) async {
    PetFile petFile = PetFile(refPet: widget.pet.id!, item: encoded);

    await PetFileService().addFile(petFile);

    petFiles.add(petFile);
    setState(() {});
  }

  void _callCallback() {
    if (widget.callback != null) {
      widget.callback!.call();
    }
  }
}
