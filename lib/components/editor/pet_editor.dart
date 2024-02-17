import 'package:adote_um_pet/components/button/elevated_button.dart';
import 'package:adote_um_pet/components/carousel/infinity_carousel.dart';
import 'package:adote_um_pet/components/picker/image_picker.dart';
import 'package:adote_um_pet/components/prompts/toast_prompt.dart';
import 'package:adote_um_pet/components/textfield/custom_textfield.dart';
import 'package:adote_um_pet/logic/cubit/pet/pet_cubit.dart';
import 'package:adote_um_pet/logic/cubit/textfield/textfield_cubit.dart';
import 'package:adote_um_pet/models/pet_entity.dart';
import 'package:adote_um_pet/models/pet_file_entity.dart';
import 'package:adote_um_pet/services/pet_file_service.dart';
import 'package:adote_um_pet/services/pet_service.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:cidades_estados_ibge/models/cidade_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

class PetEditor extends StatefulWidget {
  // TODO refactor maybe?
  final BuildContext buildContext;
  final Pet pet;
  final bool creational;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final InfinityPageController pageController = InfinityPageController();

  PetEditor({
    Key? key,
    required this.buildContext,
    required this.pet,
    required this.creational,
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
  void dispose() {

    widget.nameController.dispose();
    widget.infoController.dispose();
    widget.cityController.dispose();

    PetService().deletePet(widget.pet);
    PetFileService().deletePetFiles(widget.pet);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          color: Theme.of(context).colorScheme.background,
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
                child: BlocProvider<TextfieldCubit>(
                  create: (context) => TextfieldCubit(),
                  child: CustomTextfield(
                    label: "Nome",
                    controller: widget.nameController,
                    shouldValidate: true,
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 25, 10),
                child: BlocProvider<TextfieldCubit>(
                  create: (context) => TextfieldCubit(),
                  child: CustomTextfield(
                    label: "Info",
                    controller: widget.infoController,
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 25, 10),
                child: BlocProvider<TextfieldCubit>(
                  create: (context) => TextfieldCubit(),
                  child: CustomTextfield(
                    label: "Estado/Cidade",
                    controller: widget.cityController,
                    readOnly: true,
                    textInputType: TextInputType.text,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomElevatedButton(
                    label: "Cancelar",
                    buttonSize: ButtonSize.midSize.size,
                    onClick: () async {
                      if (widget.creational) {
                        _deletePetAndFiles();
                      } else {
                        _rollbackPet();

                        await _rollbackPetFiles();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  CustomElevatedButton(
                    label: "Confirmar",
                    buttonSize: ButtonSize.midSize.size,
                    onClick: () async {
                      widget.pet.name = widget.nameController.text;
                      widget.pet.info = widget.infoController.text;

                      context.read<PetCubit>().updatePet(pet: widget.pet);
                      Navigator.of(context).pop();
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
    petFiles = await PetFileService().getFilesByPet(widget.pet.id!);
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
}
