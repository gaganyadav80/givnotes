import 'package:get/get.dart';

class TodoDateController extends GetxController {
  final Rx<DateTime> _appBarDate = DateTime.now().obs;
  final DateTime _today = DateTime.now();

  DateTime get date => _appBarDate.value;
  set date(DateTime value) => _appBarDate.value = value;

  Rx<DateTime> get appBarDate => _appBarDate;

  bool get isToday => (date.day == _today.day && date.month == _today.month);
}
