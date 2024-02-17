import 'package:adote_um_pet/components/Button/elevated_button.dart';
import 'package:adote_um_pet/components/dropdown/dropdown_button.dart';
import 'package:adote_um_pet/components/textfield/custom_textfield.dart';
import 'package:adote_um_pet/logic/cubit/pet/pet_cubit.dart';
import 'package:adote_um_pet/logic/cubit/textfield/textfield_cubit.dart';
import 'package:adote_um_pet/preferences/preferences.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:cidades_estados_ibge/models/cidade_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class CustomCityPicker extends StatefulWidget {
  final TextEditingController cityFilterController;
  final PetCubit petCubit;

  final List<String> states = [];
  final List<String> cities = [];

  String state = "";
  String city = "";

  CustomCityPicker({
    super.key,
    required this.cityFilterController,
    required String state,
    required String city,
    required this.petCubit,
  });

  @override
  State<CustomCityPicker> createState() => _CustomCityPickerState();
}

class _CustomCityPickerState extends State<CustomCityPicker> {
  final CidadesEstadosIbge _ibgeApi = CidadesEstadosIbge();

  @override
  void initState() {
    _loadCitySelected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(children: [
        IconButton(
            onPressed: () {
              _loadStates();
              _openCitiesPane();
            },
            icon: const Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 221, 161, 94),
            )),
        Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.65,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 221, 161, 94)),
            child: TextField(
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: const InputDecoration(border: InputBorder.none),
                controller: widget.cityFilterController))
      ]),
    );
  }

  _openCitiesPane() async {
    TextEditingController filterController = TextEditingController();
    String filterText = "";

    String selectedState = "";
    String selectedCity = "";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color.fromARGB(255,254, 250, 224),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
          contentPadding: const EdgeInsets.all(14.0),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownCustomButton(
                      dropdownHint: "Selecione o Estado",
                      upperTitle: "Estado:",
                      itemList: widget.states,
                      value: selectedState,
                      onSelect: (state) {
                        setState(() {
                          selectedState = state;
                          selectedCity = "";
                          _loadCities(state);
                        });
                      },
                    ),

                    Container(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: BlocProvider<TextfieldCubit>(
                        create: (context) => TextfieldCubit(),
                        child: CustomTextfield(
                          label: "Filtrar por cidade",
                          controller: filterController,
                          textInputType: TextInputType.text,
                          shouldValidate: false,
                          onChanged: (text) {
                            setState(() => {
                              filterText =
                                  removeDiacritics(text.toLowerCase())
                            });
                          },
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: DropdownCustomButton(
                        dropdownHint: widget.cities.isEmpty
                            ? "Vazio"
                            : "Selecione a Cidade:",
                        upperTitle: "Cidade:",
                        itemList: widget.cities
                            .where((city) =>
                            removeDiacritics(city.toLowerCase()).contains(
                                removeDiacritics(filterText.toLowerCase())))
                            .toList(),
                        value: selectedCity,
                        onSelect: (city) {
                          widget.city = city;
                        },
                      ),
                    ),
                    CustomElevatedButton(
                      label: "Confirmar",
                      buttonSize: ButtonSize.midSize.size,
                      onClick: () async {
                        widget.cities.clear();
                        setCityName();
                        await widget.petCubit
                            .getPets()
                            .then((value) => {Navigator.of(context).pop()});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).then((value) async {
      if (value == null) {
        widget.city = "";
        widget.state = "";
        widget.cities.clear();
        await widget.petCubit.getPets();
      }
    });
  }

  void _loadCitySelected() async {
    int? ibgeCity = await Preferences.getIbgeCity();

    if (ibgeCity != null && ibgeCity > 0) {
      CidadeModel model = CidadesEstadosIbge().cidadePorIbge(ibgeCity);
      widget.cityFilterController.text = model.nome!;
    }
  }

  void _loadStates() {
    widget.states.clear();
    widget.states.addAll(_ibgeApi.getUfs().map((e) => e.sigla!).toList());
  }

  void _loadCities(String uf) {
    List<CidadeModel> cities = _ibgeApi.cidadesPorUf(uf);

    widget.cities.clear();
    for (CidadeModel city in cities) {
      widget.cities.add(city.nome!);
    }
  }

  void setCityName() {
    if (widget.city.isEmpty) {
      Preferences.saveIbgeCity(0);
    } else {
      Preferences.saveIbgeCity(
          _ibgeApi.buscaCidadePorNome(widget.city).first.ibge!);
    }

    setState(() {
      widget.cityFilterController.text = widget.city;
    });
  }
}
