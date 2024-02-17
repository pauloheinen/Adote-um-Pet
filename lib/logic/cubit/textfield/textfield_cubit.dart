import 'package:bloc/bloc.dart';

part 'textfield_states.dart';

class TextfieldCubit extends Cubit<TextfieldStates> {
  TextfieldCubit() : super(TextfieldInitial());

  Future<void> updateText(String text) async {
    emit(TextfieldUpdate(text: text));
  }
}
