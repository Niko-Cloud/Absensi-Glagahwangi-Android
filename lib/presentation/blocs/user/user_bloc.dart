import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../data/model/user_model.dart';
import '../../../data/repository/user_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImage>(_onUpdateUserImage);
    on<ForgetPasswordEvent>(_onForgetPassword);
  }

  void _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final UserModel user = await userRepository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Failed to fetch user'));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserUpdateLoading());
    try {
      await userRepository.updateUser(event.user, event.imageFile);
      emit(UserUpdateSuccess());
    } catch (e) {
      emit(UserUpdateFailure('Failed to update user'));
    }
  }

  void _onUpdateUserImage(UpdateUserImage event, Emitter<UserState> emit) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(UserLoaded(currentState.user, imageFile: event.imageFile));
    }
  }

  void _onForgetPassword(ForgetPasswordEvent event, Emitter<UserState> emit) async {
    emit(UserForgetPasswordLoading());
    try {
      await userRepository.forgetPasswordEvent(event.email);
      emit(UserForgetPasswordSuccess());
    } catch (e) {
      emit(UserForgetPasswordFailure('Failed to send reset password email'));
    }
  }
}
