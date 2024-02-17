import 'package:adote_um_pet/utilities/global.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'toast_states.dart';
part 'toast_events.dart';

class ToastCubit extends Bloc<ToastEvents, ToastStates> {
  ToastCubit() : super(ToastInitial());

  Stream<ToastStates> mapEventToState(ToastEvents event) async* {
    if (event is SuccessToastEvent) {
      _buildToast(event.context, event.text, Icons.check, Colors.green.shade700);
    } else if (event is WarningToastEvent) {
      _buildToast(event.context, event.text, Icons.warning, Colors.yellow.shade700);
    } else if (event is ErrorToastEvent) {
      _buildToast(event.context, event.text, Icons.dangerous, Colors.red.shade700);
    } else if (event is InformToastEvent) {
      _buildToast(event.context, event.text, Icons.info, Colors.blue.shade700);
    }
  }

  void _buildToast(
      BuildContext context, String text, IconData icon, Color color) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.transparent,
        dismissDirection: DismissDirection.startToEnd,
        elevation: 0,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.fixed,
        content: Container(
          margin: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(
                  icon,
                  size: 30,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.black,
                      ),
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black87,
                  size: 30,
                ),
                onPressed: () {
                  snackbarKey.currentState?.hideCurrentSnackBar(
                    reason: SnackBarClosedReason.dismiss,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
