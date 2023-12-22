part of 'pet_cubit.dart';

abstract class PetStates {}

class PetInitial extends PetStates {}

class PetLoading extends PetStates {}

class PetSuccess extends PetStates {
  final List<PetFilesWrapper> pets;

  PetSuccess(this.pets);
}

class PetError extends PetStates {
  final String error;

  PetError(this.error);
}
