import 'package:adote_um_pet/android/components/Border/UnderlineBorder/underline_border.dart';
import 'package:adote_um_pet/android/components/Button/elevated_button.dart';
import 'package:adote_um_pet/android/components/Dropdown/dropdown_button.dart';
import 'package:adote_um_pet/android/components/TextField/textfield.dart';
import 'package:adote_um_pet/android/preferences/preferences.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:cidades_estados_ibge/models/cidade_model.dart';
import 'package:flutter/material.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class CustomCityPicker extends StatefulWidget {
  TextEditingController cityFilterController;
  final Function()? onSelectCity;

  String sampleText = "Filtre uma cidade";
  final List<String> states = [];
  final List<String> cities = [];

  String state = "";
  String city = "";

  CustomCityPicker({
    required this.cityFilterController,
    required String state,
    required String city,
    this.onSelectCity,
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

  void click() {
    if (widget.onSelectCity != null) {
      widget.onSelectCity?.call();
    }
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
            icon: const Icon(Icons.location_on)),
        Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.65,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow[100]),
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
          backgroundColor: Colors.yellow[200],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 300,
              child: Column(
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
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
                    child: CustomTextField(
                      label: "Filtrar por cidade",
                      controller: filterController,
                      border: CustomUnderlineBorder.buildCustomBorder(),
                      onChanged: (text) {
                        setState(() {
                          filterText = removeDiacritics(text.toLowerCase());
                        });
                      },
                    ),
                  ),
                  SingleChildScrollView(
                    child: DropdownCustomButton(
                      dropdownHint: widget.cities.isEmpty
                          ? "Vazio"
                          : "Selecione a Cidade:",
                      upperTitle: "Cidade:",
                      itemList: widget.cities
                          .where((city) => removeDiacritics(city.toLowerCase())
                          .contains(
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
                    onClick: () {
                      widget.cities.clear();
                      setCityName();
                      click();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
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
        click();
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
