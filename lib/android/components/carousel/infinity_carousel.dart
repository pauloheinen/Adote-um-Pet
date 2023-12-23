import 'package:adote_um_pet/android/models/pet_entity.dart';
import 'package:flutter/material.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

import '../../models/pet_file_entity.dart';
import '../../utilities/file_util.dart';

class CustomInfinityCarousel extends StatefulWidget {
  Pet pet;
  List<PetFile> files;
  InfinityPageController controller;

  CustomInfinityCarousel({
    super.key,
    required this.pet,
    required this.files,
    required this.controller,
  });

  @override
  State<CustomInfinityCarousel> createState() => _CustomInfinityCarouselState();
}

class _CustomInfinityCarouselState extends State<CustomInfinityCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: InfinityPageView(
          controller: widget.controller,
          itemBuilder: (context, pagePosition) => (Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image(
                image: widget.files.isEmpty
                    ? FileUtil.getDefaultPetImage()
                    : FileUtil.getPetImage(
                  widget.files[pagePosition],
                ),
              ),
            ),
          )),
          onPageChanged: (value) {
            if (value != 0) {
              widget.files[value];
            }
          },
          itemCount: widget.files.length),
    );
  }


}
