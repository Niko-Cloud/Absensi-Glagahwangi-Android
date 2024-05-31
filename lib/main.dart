import 'package:absensi_glagahwangi/data/repository/event_repository.dart';
import 'package:absensi_glagahwangi/presentation/blocs/AppBlocObserver.dart';
import 'package:absensi_glagahwangi/presentation/pages/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repository/attendance_repository.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/map_repository.dart';
import 'data/repository/user_repository.dart';
import 'domain/use_case//automatic_task.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authRepository = AuthRepository();
  final userRepository = UserRepository();
  final mapRepository = MapRepository();
  final eventRepository = EventRepository();
  final attendanceRepository = AttendanceRepository();

  var user = await authRepository.user.first;

  AutomaticTask automaticTask = AutomaticTask(attendanceRepository);
  automaticTask.scheduleAutomaticAttendanceCheck(user.id!);

  runApp(App(
    authRepository: authRepository,
    eventRepository: eventRepository,
    userRepository: userRepository,
    mapRepository: mapRepository,
    attendanceRepository: attendanceRepository,
  ));
}
