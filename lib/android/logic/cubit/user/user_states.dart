part of 'user_cubit.dart';

abstract class UserStates {}

class UserInitial extends UserStates {}

class UserLoading extends UserStates {}

class UserSuccess extends UserStates {
  final User user;

  UserSuccess(this.user);
}

class UserError extends UserStates {
  final String error;

  UserError(this.error);
}
