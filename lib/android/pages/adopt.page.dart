import 'package:adote_um_pet/android/components/Button/elevated.button.dart';
import 'package:adote_um_pet/android/components/Card/Pet/pet.card.dart';
import 'package:adote_um_pet/android/components/Dropdown/dropdown.button.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:cidades_estados_ibge/models/cidade_model.dart';
import 'package:flutter/material.dart';

import '../entity/pet-file.entity.dart';
import '../entity/pet.entity.dart';
import '../preferences/preferences.dart';
import '../services/pet.service.dart';

class AdoptPage extends StatefulWidget {
  const AdoptPage({Key? key}) : super(key: key);

  @override
  State<AdoptPage> createState() => _AdoptPageState();
}

class _AdoptPageState extends State<AdoptPage> {
  final Map<Pet, PetFile> _map = {};
  final List<String> _states = List.empty(growable: true);
  final List<String> _cities = List.empty(growable: true);

  final TextEditingController _cityFilterController =
  TextEditingController(text: "Filtre uma cidade");

  CidadesEstadosIbge ibgeApi = CidadesEstadosIbge();

  String _selectedCity = "";
  String _selectedState = "";

  bool _petsLoaded = false;

  @override
  void initState() {
    _loadPreferences();
    _loadPets();
    _loadStates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow[500],
      child: Center(
        child: _petsLoaded == false
            ? const CircularProgressIndicator()
            : Scaffold(
          backgroundColor: Colors.yellow[500],
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _map.isEmpty
                ? const Center(
                child: Text("Nenhum Pet disponível para adoção"))
                : Column(
              children: [
                Padding(
                    padding:
                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(children: [
                          IconButton(
                              onPressed: () => _openCitiesPane(),
                              icon: const Icon(Icons.location_on)),
                          Expanded(
                              child: Container(
                                  height: 30,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      color: Colors.yellow[100]),
                                  child: TextField(
                                      textAlign: TextAlign.center,
                                      readOnly: true,
                                      decoration:
                                      const InputDecoration(
                                          border:
                                          InputBorder.none),
                                      controller:
                                      _cityFilterController)))
                        ]))),
                Expanded(
                    child: Container(
                        padding:
                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _map.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 350,
                              crossAxisCount: 1,
                              mainAxisSpacing: 25,
                            ),
                            itemBuilder: (context, index) {
                              final pet = _map.keys.toList()[index];
                              final files = _map.values
                                  .where((element) =>
                              element.refOwner == pet.id)
                                  .toList();
                              return PetCard.buildCard(pet, files);
                            }))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadPets() async {
    // if (_selectedCity.isNotEmpty) {
    //   _map.addAll(await PetService().getPetsFilesMap(_selectedCity));
    // }
    // TODO implement search by city selected
    _map.addAll(await PetService().getPetsFilesMap());
    setState(() {
      _petsLoaded = true;
    });
  }

  void _loadStates() async {
    _states.addAll(ibgeApi.getUfs().map((e) => e.sigla!).toList());
  }

  void _loadCities(String uf) async {
    List<CidadeModel> cities = ibgeApi.cidadesPorUf(uf);

    _cities.clear();
    for (CidadeModel city in cities) {
      _cities.add(city.nome!);
    }
  }

  _openCitiesPane() async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.yellow[200],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: DropdownCustomButton(
                        dropdownHint: "Selecione o Estado",
                        upperTitle: "Estado:",
                        itemList: _states,
                        value: _selectedState,
                        onSelect: (state) {
                          setState(() {
                            _selectedState = state;
                            _selectedCity = "";
                            _loadCities(state);
                          });
                        })),
                Expanded(
                    child: DropdownCustomButton(
                        dropdownHint:
                        _cities.isEmpty ? "Vazio" : "Selecione a Cidade:",
                        upperTitle: "Cidade:",
                        itemList: _cities,
                        value: _selectedCity,
                        onSelect: (city) {
                          _selectedCity = city;
                        })),
                CustomElevatedButton(
                    label: "Confirmar",
                    onClick: () {
                      _cities.clear();
                      Preferences.saveCityOption(_selectedCity);
                      Navigator.of(context).pop();
                      setCityName();
                    })
              ],
            ),
          ),
        ),
      ),
    ).then((value) async {
      if (value == null) {
        _selectedCity = "";
        _selectedState = "";
        _cities.clear();
      }
    });
  }

  void setCityName() {
    setState(() {
      _cityFilterController.text = _selectedCity;
    });
  }

  void _loadPreferences() async {
    String? cityOption = await Preferences.getCityOption();

    if (cityOption != null) {
      _cityFilterController.text = cityOption;
      _selectedCity = cityOption;
    }
  }
}
