import 'package:adote_um_pet/android/utilities/File/file.util.dart';
import 'package:flutter/material.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

import '../../../entity/pet-file.entity.dart';
import '../../../entity/pet.entity.dart';

class PetCard {
  static final InfinityPageController pageController =
      InfinityPageController(initialPage: 0);

  static Widget buildCard(Pet pet, List<PetFile> files) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.yellow[100],
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: InfinityPageView(
                      controller: pageController,
                      itemBuilder: (context, pagePosition) => (Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Image(
                                  image: files.isEmpty ? FileUtil.getDefaultPetImage() : FileUtil.getPetImage(
                                      files[pagePosition]))))),
                      itemCount: files.length))),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Text(
                      "nome: ${pet.name}\nVacinado: ${pet.vaccinated}\nTutor: ${pet.refOwner}\nCidade: cidade1",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
              const Spacer(),
              PopupMenuButton<int>(
                shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                onSelected: (value) {
                  if (value == 1) {
                    print(pet);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                      value: 1,
                      child:
                          Text("Visualizar", style: TextStyle(fontSize: 12))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
