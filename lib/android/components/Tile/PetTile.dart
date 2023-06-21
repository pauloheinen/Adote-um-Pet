import 'package:flutter/material.dart';

import '../../entity/pet.entity.dart';

class PetTile {
  Widget createListTile(Pet pet) {
    return Material(
      child: ListTile(
        tileColor: Colors.purpleAccent,
        enableFeedback: false,
        isThreeLine: true,
        splashColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(15),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        title: Text(
          pet.name,
          style: const TextStyle(fontSize: 18),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        subtitle: Text(
          Pet.getStatus(pet.vaccinated),
          style: const TextStyle(fontSize: 18),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        trailing: PopupMenuButton<int>(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.blueGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          onSelected: (value) {
            if (value == 1) {
              _openProfile(pet);
            } else if (value == 2) {
              _openChat(pet);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 1,
              child: Text(
                "Visualizar",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Tenho interesse",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openChat(Pet pet) {

}

void _openProfile(Pet pet) {

}
