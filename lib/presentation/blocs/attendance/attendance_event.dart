part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class RecordAttendanceIn extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String location;
  final String imagePath;

  const RecordAttendanceIn(this.uid, this.date, this.location, this.imagePath);

  @override
  List<Object> get props => [uid, date, location, imagePath];
}

class RecordAttendanceOut extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String location;
  final String imagePath;

  const RecordAttendanceOut(this.uid, this.date, this.location, this.imagePath);

  @override
  List<Object> get props => [uid, date, location, imagePath];
}

class CheckAttendanceStatus extends AttendanceEvent {
  final String uid;
  final DateTime date;

  const CheckAttendanceStatus(this.uid, this.date);

  @override
  List<Object> get props => [uid, date];
}

class SubmitPermissionForm extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String type;
  final String description;
  final String imagePath;

  const SubmitPermissionForm(this.uid, this.date, this.type, this.description, this.imagePath);

  @override
  List<Object> get props => [uid, date, type, description, imagePath];
}

class SubmitDinasForm extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String description;
  final String filePath;

  const SubmitDinasForm(this.uid, this.date, this.description, this.filePath);

  @override
  List<Object> get props => [uid, date, description, filePath];
}

class RecordOvertime extends AttendanceEvent {
  final String uid;
  final DateTime date;

  const RecordOvertime(this.uid, this.date);

  @override
  List<Object> get props => [uid, date];
}

class ForgetAttendance extends AttendanceEvent {
  final String uid;
  final DateTime date;
  final String filePath;
  final String description;

  const ForgetAttendance(this.uid, this.date, this.filePath, this.description);

  @override
  List<Object> get props => [uid, date, filePath, description];
}
