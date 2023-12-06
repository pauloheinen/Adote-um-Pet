import 'package:adote_um_pet/android/components/Card/Pet/pet_card.dart';
import 'package:adote_um_pet/android/components/Loading/loading_box.dart';
import 'package:adote_um_pet/android/components/Picker/city_picker.dart';
import 'package:cidades_estados_ibge/cidades_estados_ibge.dart';
import 'package:flutter/material.dart';

import '../entities/pet_entity.dart';
import '../entities/pet_file_entity.dart';
import '../preferences/preferences.dart';
import '../services/pet_service.dart';

class AdoptPage extends StatefulWidget {
  const AdoptPage({Key? key}) : super(key: key);

  @override
  State<AdoptPage> createState() => _AdoptPageState();
}

class _AdoptPageState extends State<AdoptPage> {
  final Map<Pet, List<PetFile>> _map = {};

  final TextEditingController _cityFilterController = TextEditingController();

  String _selectedCity = "";
  String _selectedState = "";

  bool _petsLoaded = false;

  @override
  void initState() {
    _loadPreferences();
    _loadPets();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow[500],
      child: Center(
        child: _petsLoaded == false
            ? const CustomLoadingBox()
            : Scaffold(
                backgroundColor: Colors.yellow[500],
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: _map.isEmpty
                      ? Column(
                          children: [
                            CustomCityPicker(
                                cityFilterController: _cityFilterController,
                                city: _selectedCity,
                                state: _selectedState,
                            onSelectCity: () => _loadPets,),
                            const Spacer(),
                            const Center(
                                child:
                                    Text("Nenhum Pet disponível para adoção")),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            CustomCityPicker(
                              cityFilterController: _cityFilterController,
                              state: _selectedState,
                              city: _selectedCity,
                              onSelectCity: () => _loadPets,
                            ),
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
                                      final files =
                                          _map.values.elementAt(index);
                                      return PetCard(pet: pet, files: files);
                                    }),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  void _loadPets() async {
    int? ibgeCity = await Preferences.getIbgeCity();

    if (ibgeCity != null) {
      _map.clear();
      _map.addAll(await PetService().getPetsFilesMapByCityId(ibgeCity));
    }

    setState(() {
      _petsLoaded = true;
    });
  }

  void _loadPreferences() async {
    int? ibgeCity = await Preferences.getIbgeCity();

    if (ibgeCity != null) {
      String cityName = CidadesEstadosIbge().cidadePorIbge(ibgeCity).nome!;
      _cityFilterController.text = cityName;
      _selectedCity = cityName;
    }
  }
}
