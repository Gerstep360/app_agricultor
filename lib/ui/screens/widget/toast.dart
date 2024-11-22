import 'package:fluttertoast/fluttertoast.dart';

void toast(String msj) async =>
    Fluttertoast.showToast(timeInSecForIosWeb: 3, msg: msj);
