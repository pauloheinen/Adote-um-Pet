part of 'textfield_cubit.dart';

abstract class TextfieldStates {}

class TextfieldInitial extends TextfieldStates {}

class TextfieldUpdate extends TextfieldStates {
  final String text;

  TextfieldUpdate({required this.text});
}

// class TextfieldChange extends TextfieldStates {
//   final String text;
//
//   TextfieldChange({text});
// }