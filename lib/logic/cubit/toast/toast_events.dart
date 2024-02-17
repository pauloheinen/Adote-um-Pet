part of 'toast_cubit.dart';

abstract class ToastEvents {}

class SuccessToastEvent extends ToastEvents {
  final BuildContext context;
  final String text;

  SuccessToastEvent(this.context, this.text);
}

class WarningToastEvent extends ToastEvents {
  final BuildContext context;
  final String text;

  WarningToastEvent(this.context, this.text);
}

class ErrorToastEvent extends ToastEvents {
  final BuildContext context;
  final String text;

  ErrorToastEvent(this.context, this.text);
}

class InformToastEvent extends ToastEvents {
  final BuildContext context;
  final String text;

  InformToastEvent(this.context, this.text);
}
